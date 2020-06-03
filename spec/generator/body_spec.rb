RSpec.describe HatenablogPublisher::Generator::Body do
  describe '.replace_image' do
    let(:options) { HatenablogPublisher::Options.new(filename: './spec/support/sample2.md') }
    let(:context) do
      io = HatenablogPublisher::Io.new(options)
      HatenablogPublisher::Context.new(io)
    end

    subject { HatenablogPublisher::Generator::Body.new(context, options).replace_image(context.text) }

    context '直リンクの画像が含まれる時' do
      it 'そのまま出力されているか' do
        is_expected.to include('![alt](http://dummyimage.com/570×295)')
      end
    end

    context '画像が含まれる時' do
      it 'はてな記法に変換されているか' do
        is_expected.to include('[f:id:hoge:11111111111111p:image]')
        is_expected.to include('[f:id:hoge:22222222222222p:image]')
      end
    end
  end
end
