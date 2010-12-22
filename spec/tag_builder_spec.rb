require 'spec_helper'

describe Formtastic::TagBuilder do
  before(:each) { @builder = Formtastic::TagBuilder.new(ActionView::Base.new) }

  describe '#fieldset' do
    it 'returns a fieldset tag' do
      @builder.fieldset.should have_tag('fieldset')
    end

    it 'returns a fieldset tag with content' do
      @builder.fieldset('foo').should have_tag('fieldset', 'foo')
    end

    it 'returns a fieldset with an OL' do
      html = @builder.fieldset do |fieldset|
        fieldset.ol
      end

      html.should have_tag('fieldset ol')
    end

    context 'when a legend and ol are defined in a fieldset' do
      before(:each) do
        @html = @builder.fieldset do |fieldset|
          fieldset.legend('foo')
          fieldset.ol
        end
      end

      it 'returns a fieldset with a legend' do
        @html.should have_tag('fieldset legend','foo')
      end

      it 'returns a fieldset with an ol' do
        @html.should have_tag('fieldset ol')
      end
    end
  end

  describe '#ol' do
    before(:each) do
      @html = @builder.ol do |ol|
        ol.li('foo')
        ol.li('bar')
      end
    end

    it 'returns an LI with foo content in it' do
      @html.should have_tag('ol li', 'foo')
    end

    it 'returns an LI with bar content in it' do
      @html.should have_tag('ol li', 'foo')
    end
  end

  describe '#ol', 'when OLs are nested within LIs' do
    before(:each) do
      @html = @builder.ol do |ol|
        ol.li('foo top level')

        ol.li do |li|
          li.ol do |ol_2|
            ol_2.li('foo second level')
            ol_2.li('bar second level')
          end
        end

        ol.li('bar top level')
      end
    end

    it 'returns an OL with an LI containing "foo top level"' do
      @html.should have_tag('ol li', 'foo top level')
    end

    it 'returns an OL with an LI containing "bar top level"' do
      @html.should have_tag('ol li', 'bar top level')
    end

    it 'returns an OL with an LI, with an OL and an LI containing "foo second level"' do
      @html.should have_tag('ol li ol li', 'foo second level')
    end

    it 'returns an OL with an LI, with an OL and an LI containing "bar second level"' do
      @html.should have_tag('ol li ol li','bar second level')
    end
  end
end
