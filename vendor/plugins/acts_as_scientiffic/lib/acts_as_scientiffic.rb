#require 'image_science'

module Foo
  module Acts #:nodoc:
    module Scientiffic

      def self.included(mod)
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_scientiffic
          include Foo::Acts::Scientiffic::InstanceMethods
        end
      end

      module InstanceMethods
        def save # no callbacks
          returning super do
            self.save_content
          end
        end

        def save!
          returning super do
            self.save_content
          end
        end

        def save_content
          if content_dirty? then
            path = self.file_path
            dir = File.dirname(path)
            FileUtils.mkdir_p dir unless test ?d, dir
            File.open(path, "w") do |f|
              f.write self.content
            end

            # skipping for now
            mark_content_clean
            self.content
          end
        end

        def mark_content_dirty
          @content_dirty = true
        end

        ##
        # Marks the content as clean
        def mark_content_clean
          @content_dirty = false
        end

        # Checks whether the content is dirty
        def content_dirty?
          @content_dirty
        end


        def thumbnail(size, proportional = true)
          return nil unless test ?f, self.file_path
          thumbnail_path = "#{RAILS_ROOT}/public/photos/#{self.id};custom_size?size=#{size}"
          thumbnail_path += "&square=t" unless proportional
          thumbnail_path += ".png"
          Tempfile.open(self.id.to_s, "#{RAILS_ROOT}/tmp") do |file|
            file.write(self.content)
            file.flush

            ImageScience.with_image(file.path) do |thumb|
              if thumb.width > size or thumb.height > size
                msg = (proportional ? :thumbnail : :cropped_thumbnail)
                thumb.send(msg, size) do |img|
                  img.save(thumbnail_path)
                end
              else
                thumb.save(thumbnail_path)
              end
            end
          end

          File.read(thumbnail_path)
        end

        def content=(value)
          mark_content_dirty
          @content = value
        end

        def file_path
          "#{RAILS_ROOT}/public/photos/#{self.id};raw"
        end

        def content
          return @content if @content
          path = self.file_path
          return nil unless test ?f, path
          @content = File.read(path)
        end

      end

    end
  end
end

ActiveRecord::Base.class_eval do
  include Foo::Acts::Scientiffic
end
