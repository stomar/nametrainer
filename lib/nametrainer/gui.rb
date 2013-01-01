require 'iconv'  if RUBY_VERSION < '1.9' # utf-8 -> latin1 for QLabel

module Nametrainer

  # Class for the application window.
  class GUI < Qt::Widget

    # Initializes the application window.
    # You can specify a collection that is loaded at startup.
    #
    # +collection_dir+ - path to collection
    def initialize(options)
      super()

      set_window_title 'Name Trainer'
      resize 600, 500

      # the common variables
      @collection_dir = nil
      @collection = nil
      @person = nil
      @statistics = Nametrainer::Statistics.new

      # the common widgets
      @collection_label = Qt::Label.new '<i>No collection loaded</i>'
      @image_label = Qt::Label.new
      @image = Qt::Pixmap.new
      @name_label = Qt::Label.new
      @statistics_label = Qt::Label.new @statistics.to_s
      @ordered_checkbox = Qt::CheckBox.new 'Non-random order'
      @display_checkbox = Qt::CheckBox.new "Display name at once"

      if options[:learning_mode]
        @ordered_checkbox.set_checked true
        @display_checkbox.set_checked true
      end

      init_gui
      show

      collection_dir = options[:collection]
      init_collection File.expand_path(collection_dir)  unless collection_dir.nil?
    end

    # Initializes the GUI layout and functions.
    def init_gui
      name_fontsize = 24
      name_font = Qt::Font.new { setPointSize name_fontsize }
      @name_label.set_font name_font
      @image_label.set_size_policy Qt::SizePolicy::Ignored, Qt::SizePolicy::Ignored

      # create buttons
      @show = Qt::PushButton.new '&Display Name', self do
        #set_tool_tip 'S'
        set_shortcut Qt::KeySequence.new(Qt::Key_D.to_i)
      end
      @correct = Qt::PushButton.new 'Correct', self do
        #set_tool_tip 'F'
        set_shortcut Qt::KeySequence.new(Qt::Key_S.to_i)
      end
      @wrong = Qt::PushButton.new 'Wrong', self do
        #set_tool_tip 'D'
        set_shortcut Qt::KeySequence.new(Qt::Key_F.to_i)
      end
      load_collection = Qt::PushButton.new '&Load Collection', self do
        #set_tool_tip 'L'
        set_shortcut Qt::KeySequence.new(Qt::Key_L.to_i)
      end
      help = Qt::PushButton.new '&Help', self do
        #set_tool_tip 'H'
        set_shortcut Qt::KeySequence.new(Qt::Key_H.to_i)
      end
      quit = Qt::PushButton.new 'Quit', self do
        #set_tool_tip 'Ctrl+W'
        set_shortcut Qt::KeySequence.new(Qt::CTRL.to_i + Qt::Key_W.to_i)
      end

      # Connect the buttons to slots.
      connect load_collection, SIGNAL(:clicked), self, SLOT(:load_collection)
      connect quit, SIGNAL(:clicked), self, SLOT(:quit)
      connect help, SIGNAL(:clicked), self, SLOT(:show_help)
      connect @correct, SIGNAL(:clicked), self, SLOT(:correct_answer)
      connect @wrong, SIGNAL(:clicked), self, SLOT(:wrong_answer)
      connect @show, SIGNAL(:clicked), self, SLOT(:display_name)

      # Start with buttons disabled.
      disable_buttons

      # Create the layout.
      vbox = Qt::VBoxLayout.new self
      mainbox = Qt::HBoxLayout.new

      vbox.add_widget @collection_label

      left = Qt::VBoxLayout.new
      left.add_widget @image_label, 1
      left.add_widget @name_label

      answer_buttons = Qt::HBoxLayout.new
      answer_buttons.add_widget @correct
      answer_buttons.add_widget @wrong

      right = Qt::VBoxLayout.new
      right.add_widget @show
      right.add_layout answer_buttons
      right.add_stretch 1
      right.add_widget Qt::Label.new 'Statistics:'
      right.add_widget @statistics_label
      right.add_stretch 1
      right.add_widget @ordered_checkbox
      right.add_widget @display_checkbox
      right.add_stretch 1
      right.add_widget load_collection
      right.add_widget help
      right.add_widget quit

      mainbox.add_layout left, 1
      mainbox.add_layout right

      vbox.add_layout mainbox

      set_layout vbox
    end

    slots :load_collection, :quit, :show_help, :display_name, :correct_answer, :wrong_answer

    # Opens a file dialog and tries to load a collection.
    def load_collection
      collection_dir = Qt::FileDialog.get_existing_directory self, 'Load Collection'
      return  if collection_dir.nil?
      init_collection File.expand_path(collection_dir)
    end

    # Tries to load a collection (does not change anything if load fails).
    #
    # +collection_dir+ - path to collection
    def init_collection(collection_dir)
      args = {
        :directory  => collection_dir,
        :extensions => Nametrainer::FILE_EXTENSIONS
      }
      collection = Nametrainer::CollectionLoader.load(args)
      if collection.nil? or collection.empty?
        Qt::MessageBox.warning self, 'Error', Nametrainer.collection_empty_message
        return
      end
      @collection_dir = collection_dir
      @collection = collection
      @collection_label.set_text "Collection: #{File.basename(@collection_dir)}"
      @statistics.reset
      @statistics_label.set_text @statistics.to_s
      @person = nil
      choose_person
    end

    # Disables the buttons that are only needed when a collection is loaded.
    def disable_buttons
      @correct.set_enabled false
      @wrong.set_enabled false
      @show.set_enabled false
    end

    # Enables the buttons that are only needed when a collection is loaded.
    def enable_buttons
      @correct.set_enabled true
      @wrong.set_enabled true
      @show.set_enabled true
    end

    # Quits application.
    def quit
      Qt::Application.instance.quit
    end

    # Shows the help window.
    def show_help
      Qt::MessageBox.about self, 'Help', Nametrainer.help_message
    end

    # Displays the name of the shown person and disables the <tt>Display Name</tt> button.
    def display_name
      # convert name string from utf-8 to latin1 (for QLabel)
      if RUBY_VERSION < '1.9'
        name_latin1 = Iconv.conv('LATIN1', 'UTF-8', @person.name)
      else
        name_latin1 = @person.name.encode('ISO-8859-1', 'UTF-8')
      end
      @name_label.set_text name_latin1
      @show.set_enabled false
    end

    # Called when +Correct+ button is clicked.
    def correct_answer
      handle_answer(:correct)
    end

    # Called when +Wrong+ button is clicked.
    def wrong_answer
      handle_answer(:wrong)
    end

    # Handles correct and wrong answers, and chooses the next person.
    #
    # +answer+ - <tt>:correct</tt> or <tt>:wrong</tt>
    def handle_answer(answer)
      update_statistics(answer)
      update_scores(answer)
      choose_person
    end

    # Updates the statistics depending on answer.
    def update_statistics(answer)
      case answer
      when :correct
        @statistics.correct += 1
      when :wrong
        @statistics.wrong += 1
      end
      @statistics_label.set_text @statistics.to_s
    end

    # Increases the score for correctly recognized persons.
    def update_scores(answer)
      @person.increase_score  if answer == :correct
    end

    # Displays the image, scaled as large as possible.
    def show_image
      if @image.null?
        @image_label.set_text "<i>Unable to display `#{File.basename(@person.image)}'.</i>"
      else
        @image_label.set_pixmap @image.scaled(@image_label.size, Qt::KeepAspectRatio)
      end
    end

    # Chooses and displays the next person,
    # erases the displayed name, and enables the <tt>Display Name</tt> button.
    # "Next" means a random sample or, if the <tt>Non-random order</tt> checkbox is checked,
    # the successor of the current person in the collection array.
    def choose_person
      @name_label.set_text ''
      if @ordered_checkbox.is_checked
        @person = @collection.successor(@person)
      else
        @person = @collection.sample
      end
      @image.load @person.image or @image = Qt::Pixmap.new  # delete image when load fails
      show_image
      enable_buttons
      display_name  if @display_checkbox.is_checked
    end

    # Repaints the image when the application window is resized.
    def resizeEvent(event)
      return  if @image.nil? || @image.null?
      scaledSize = @image.size.scale(@image_label.size, Qt::KeepAspectRatio)
      show_image  if scaledSize != @image_label.pixmap.size
    end
  end
end
