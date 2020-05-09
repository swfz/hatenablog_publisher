require 'ostruct'
require 'oauth'
require 'awesome_print'

RSpec.describe HatenablogPublisher::Context do

  describe "初回投稿時の状態のマークダウン" do
    describe "読み込み時" do
      it "タイトル,カテゴリが読み込めているか" do
        context = described_class.new('./spec/support/sample.md')
        expect(context.title).to eq 'サンプルマークダウン'
        expect(context.categories).to eq ['Markdown', 'Sample']
        expect(context.hatena).to be_empty
      end
    end
  end
  describe "更新投稿時の状態のマークダウン" do
    describe "読み込み時" do
      it "タイトル,カテゴリ,entry id, photolifeのデータが読み込めているか" do

        hatena = { image:
          {
            'sample01.png': {
              syntax: '[f:id:hoge:11111111111111p:image]',
              id: 'tag:hatena.ne.jp,2005:fotolife-hoge-11111111111111',
              image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150000.png'
            },
            'sample02.png': {
              syntax: '[f:id:hoge:22222222222222p:image]',
              id: 'tag:hatena.ne.jp,2005:fotolife-hoge-22222222222222',
              image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150001.png'
            }
          },
          id: '11111111111111111'
        }

        context = described_class.new('./spec/support/sample2.md')
        expect(context.title).to eq 'サンプルマークダウン'
        expect(context.categories).to eq ['Markdown', 'Sample']
        expect(context.hatena).to eq hatena
      end
    end
  end

  describe "image POST後" do
    let(:image1_context) { {syntax: '[f:id:hoge:11111111111111p:image]', id: 'tag:hatena.ne.jp,2005:fotolife-hoge-11111111111111', image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150000.png'} }
    let(:image2_context) { {syntax:  '[f:id:hoge:22222222222222p:image]', id: 'tag:hatena.ne.jp,2005:fotolife-hoge-22222222222222', image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150001.png'} }
    describe "add_context" do
      let(:xml1) {OpenStruct.new(body: File.read('spec/support/photolife-sample01-response.xml'))}
      let(:xml2) {OpenStruct.new(body: File.read('spec/support/photolife-sample02-response.xml'))}
      let(:photolife_api) {HatenablogPublisher::Photolife.new}
      let(:image1) {HatenablogPublisher::Image.new('spec/support/sample01.png')}
      let(:image2) {HatenablogPublisher::Image.new('spec/support/sample02.png')}
      let(:context) {described_class.new('spec/support/sample.md')}

      before do
        allow(photolife_api.client.client).to receive(:request).and_return(xml1, xml2)
      end

      it "photolifeのデータが読み込めているか" do
        hash1 = photolife_api.upload(image1)
        hash2 = photolife_api.upload(image2)
        context.add_image_context(hash1, 'sample01.png')
        context.add_image_context(hash2, 'sample02.png')

        expect_image = {
          'sample01.png': image1_context,
          'sample02.png': image2_context
        }
        expect(context.hatena[:image]).to eq expect_image
      end
    end
  end

  describe "entry POST後" do
    describe "add_context" do
      let(:xml) { OpenStruct.new(body: File.read('spec/support/entry-sample.md-response.xml')) }
      let(:context) { described_class.new('spec/support/sample.md') }
      let(:options) { HatenablogPublisher::Options.new({}) }
      let(:entry_api) { HatenablogPublisher::Entry.new(context, options) }

      before do
        allow(entry_api.client.client).to receive(:request).and_return(xml)
      end

      it "タイトル,カテゴリ,entry idのデータが読み込めているか" do
        hash = entry_api.post_entry('dummy')
        context.add_entry_context(hash)
        expect_hatena = {
          id: '11111111111111111'
        }

        expect(context.title).to eq 'サンプルマークダウン'
        expect(context.categories).to eq ['Markdown', 'Sample']
        expect(context.hatena).to eq expect_hatena
      end
    end
  end
end
