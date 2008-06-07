module Tags
  class Context < Radius::Context

    attr_reader :reference

    def initialize(reference)
      super()

      @reference = reference
      globals.object = reference

      reference.tags.each do |tag|
        define_tag(tag) { |tag_binding| reference.render_tag(tag, tag_binding) }
      end

    end

  end
end