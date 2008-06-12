module Tags
  class Context < Radius::Context

    attr_reader :reference

    def initialize(reference)
      super()

      @reference = reference
      globals.object = reference
      globals.section = reference.is_a?(Section) ? reference : reference.section rescue nil
      globals.cache = SharedCache.instance

      reference.tags.each do |tag|
        define_tag(tag) { |tag_binding| reference.render_tag(tag, tag_binding) }
      end

    end

  end
end