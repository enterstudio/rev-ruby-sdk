require_relative '../../../spec_helper'

describe 'OrderRequest' do

  it 'defaults to standard TAT guarantee' do
    order = Rev::OrderRequest.new({})
    order.non_standard_tat_guarantee.must_equal false
  end

  it 'accepts non standard TAT guarantee flag during init' do
    non_standard_tat_guarantee = true
    order = Rev::OrderRequest.new({ 'non_standard_tat_guarantee' => non_standard_tat_guarantee })
    order.non_standard_tat_guarantee.must_equal non_standard_tat_guarantee
  end

  it 'has caption options' do
    order = Rev::OrderRequest.new({})
    order.must_respond_to :caption_options
  end

  describe 'InputOptions' do
    it 'is ApiSerializable' do
      options = Rev::InputOptions.new([{}], {})
      options.must_be_kind_of Rev::ApiSerializable
    end

    it 'requires non-empty inputs' do
      proc { Rev::InputOptions.new([]) }.must_raise ArgumentError
    end

    it 'requires non-nil inputs' do
      proc { Rev::InputOptions.new(nil) }.must_raise ArgumentError
    end

    it 'sets inputs from init' do
      inputs = ['foo']
      options = Rev::InputOptions.new(inputs)
      options.inputs.must_equal inputs
    end
  end

  describe 'TranscriptionOptions' do
    it 'is InputOptions' do
      options = Rev::TranscriptionOptions.new([{}], {})
      options.must_be_kind_of Rev::InputOptions
    end
  end

  describe 'CaptionOptions' do
    it 'is InputOptions' do
      options = Rev::CaptionOptions.new([{}], {})
      options.must_be_kind_of Rev::InputOptions
    end

    it 'has output file formats attribute' do
      options = Rev::CaptionOptions.new([{}], {})
      options.must_respond_to :output_file_formats
    end

    it 'has output file formats hash' do
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:subrip].must_equal 'SubRip'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:scc].must_equal 'Scc'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:mcc].must_equal 'Mcc'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:ttml].must_equal 'Ttml'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:qttext].must_equal 'QTtext'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:transcript].must_equal 'Transcript'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:webvtt].must_equal 'WebVtt'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:dfxp].must_equal 'Dfxp'
      Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:cheetahcap].must_equal 'CheetahCap'
    end

    it 'rejects unknowns file formats' do
      proc { Rev::CaptionOptions.new([{}], { :output_file_formats => ['invalid'] }) }.must_raise ArgumentError
    end

    it 'accepts valid file formats' do
      order = Rev::CaptionOptions.new([{}], { :output_file_formats => [Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:scc]] })
      order.output_file_formats.length.must_equal 1
      order.output_file_formats[0].must_equal Rev::CaptionOptions::OUTPUT_FILE_FORMATS[:scc];
    end
  end # CaptionOptions

  describe 'Notification' do
    it 'Defaults level' do
      notification = Rev::Notification.new('http://example.com/')
      notification.level.must_equal Rev::Notification::LEVELS[:final_only]
    end
  end # Notification
end
