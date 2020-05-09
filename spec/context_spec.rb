RSpec.describe HatenablogPublisher::Context do
  describe "初回投稿時の状態のマークダウン" do
    describe "読み込み時" do
      it "タイトル,カテゴリが読み込めているか" do
        context = HatenablogPublisher::Context.new('./spec/support/sample.md')
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
              image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/swfz/20200509/20200509150000.png'
            },
            'sample02.png': {
              syntax: '[f:id:hoge:22222222222222p:image]',
              id: 'tag:hatena.ne.jp,2005:fotolife-hoge-22222222222222',
              image_url: 'https://cdn-ak.f.st-hatena.com/images/fotolife/s/swfz/20200509/20200509150001.png'
            }
          },
          id: '11111111111111111'
        }

        context = HatenablogPublisher::Context.new('./spec/support/sample2.md')
        expect(context.title).to eq 'サンプルマークダウン'
        expect(context.categories).to eq ['Markdown', 'Sample']
        expect(context.hatena).to eq hatena
      end
    end
  end

  describe "image POST後" do
    describe "context更新後" do
      it "photolifeのデータが読み込めているか" do
      end
    end
  end

  describe "entry POST後" do
    describe "context更新後" do
      it "タイトル,カテゴリ,entry idのデータが読み込めているか" do
      end
    end
  end
end
