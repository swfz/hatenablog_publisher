require 'ostruct'
require 'oauth'
require 'awesome_print'

RSpec.describe HatenablogPublisher::Context do
  let(:image1_context) { {syntax: '[f:id:hoge:11111111111111p:image]', id: 'tag:hatena.ne.jp,2005:fotolife-hoge-11111111111111', image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150000.png'} }
  let(:image2_context) { {syntax:  '[f:id:hoge:22222222222222p:image]', id: 'tag:hatena.ne.jp,2005:fotolife-hoge-22222222222222', image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150001.png'} }
  let(:categories) { ['Markdown', 'Sample'] }
  let(:title) { 'サンプルマークダウン' }

  describe '.read_context' do
    context '初回投稿時の状態の.md' do
      let(:context) do
        options = HatenablogPublisher::Options.new(filename: './spec/support/sample.md')
        io = HatenablogPublisher::Io.new(options)
        described_class.new(io)
      end
      subject {context}

      it 'title,categoryが読めているか' do
        is_expected.to have_attributes(title: title, categories: categories)
      end

      it 'hatenaは空か' do
        expect(context.hatena).to be_empty
      end
    end

    context '更新投稿時の.md' do
      subject do
        options = HatenablogPublisher::Options.new(filename: './spec/support/sample2.md')
        io = HatenablogPublisher::Io.new(options)
        described_class.new(io)
      end
      let(:hatena) do {
        image: {
          'sample01.png': image1_context,
          'sample02.png': image2_context
        },
        id: '11111111111111111'
      }
      end

      it 'title,category,hatenaが読めているか' do
        is_expected.to have_attributes(title: title, categories: categories, hatena: hatena)
      end
    end
  end

  describe '.add_image_context' do
    let(:xml1) {OpenStruct.new(body: File.read('spec/support/photolife-sample01-response.xml'))}
    let(:xml2) {OpenStruct.new(body: File.read('spec/support/photolife-sample02-response.xml'))}
    let(:photolife_api) {HatenablogPublisher::Photolife.new}
    let(:image1) {HatenablogPublisher::Image.new('spec/support/sample01.png')}
    let(:image2) {HatenablogPublisher::Image.new('spec/support/sample02.png')}
    let(:context) do
      options = HatenablogPublisher::Options.new(filename: './spec/support/sample.md')
      io = HatenablogPublisher::Io.new(options)
      described_class.new(io)
    end

    before do
      allow(photolife_api.client.client).to receive(:request).and_return(xml1, xml2)
    end

    context '初回投稿 単発image' do
      let(:image_hash1) {photolife_api.upload(image1)}

      it 'photolifeのデータが追加されているか' do
        expect { context.add_image_context(image_hash1, 'sample01.png') }.to \
        change(context, :hatena)
        .from({})
        .to({image: {'sample01.png': image1_context}})
      end
    end

    context '初回投稿 複数image' do
      before do
        hash1 = photolife_api.upload(image1)
        context.add_image_context(hash1, 'sample01.png')
      end

      let(:image_hash2) {photolife_api.upload(image2)}

      it 'photolifeのデータが追加されているか' do
        expect { context.add_image_context(image_hash2, 'sample02.png') }.to \
        change(context, :hatena)
        .from({image: {'sample01.png': image1_context}})
        .to({image: {'sample01.png': image1_context, 'sample02.png': image2_context}})
      end
    end
  end

  describe '.add_entry_context' do
    let(:xml) { OpenStruct.new(body: File.read('spec/support/entry-sample.md-response.xml')) }
    let(:options) { HatenablogPublisher::Options.new(filename: './spec/support/sample.md') }
    let(:io) { HatenablogPublisher::Io.new(options) }
    let(:context) { described_class.new(io) }
    let(:entry_api) { HatenablogPublisher::Entry.new(context, options) }

    before do
      allow(entry_api.client.client).to receive(:request).and_return(xml)
    end

    context '初回投稿時' do
      let(:entry_hash) {entry_api.post_entry('dummy text')}

      it 'entry_idが追加されているか' do
        expect { context.add_entry_context(entry_hash) }.to \
        change(context, :hatena)
        .from({})
        .to({id: '11111111111111111'})
      end
    end

    context '更新投稿時' do
      let(:options) { HatenablogPublisher::Options.new(filename: './spec/support/sample2.md') }
      let(:entry_hash) {entry_api.post_entry('dummy text')}
      let!(:before_hatena) {context.hatena}

      it '何も変更がないか' do
        expect { context.add_entry_context(entry_hash) }.not_to  change{context.hatena}.from(before_hatena)
      end
    end
  end
end
