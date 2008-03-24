class ImageGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      
      # Controller
      m.file "controllers/content_controller.rb", "app/controllers/content_controller.rb"
      
      # Model
      m.file "models/content.rb", "app/models/content.rb"
      
      # Tests
      m.file "test/unit/content_test.rb", "test/unit/content_test.rb"
      m.file "test/functional/content_controller_test.rb", "test/functional/content_controller_test.rb"
      
    end
  end
end
