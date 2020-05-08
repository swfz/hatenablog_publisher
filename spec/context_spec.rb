RSpec.describe HatenablogPublisher::Context do
  describe "初回投稿時の状態のマークダウン" do
    describe "読み込み時" do
      it "タイトル,カテゴリが読み込めているか" do
        context = HatenablogPublisher::Context.new('./spec/support/sample.md')
        expect(context.title).to eq 'サンプルマークダウン'
        expect(context.categories).to eq ['Markdown', 'Sample']
        expect(context.hatena).to be nil
      end
    end
  end
  describe "更新投稿時の状態のマークダウン" do
    describe "読み込み時" do
      it "タイトル,カテゴリ,entry id, photolifeのデータが読み込めているか" do
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
