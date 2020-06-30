require 'ostruct'

RSpec.describe HatenablogPublisher::FixedContent::Ad do
  let(:ad_type) { 'html' }
  let(:options) { OpenStruct.new(ad_file: 'spec/support/ad_file.yml', ad_type: ad_type) }
  let(:max_size) { HatenablogPublisher::FixedContent::Ad::MAX_AD_SIZE }
  let(:has_4_ads_category) { 'Markdown' }
  let(:has_2_ads_category1) { 'Ruby' }
  let(:has_2_ads_category2) { 'Python' }
  let(:no_ads_category) { 'AWS' }

  describe '#sample_items' do
    subject(:ads) { HatenablogPublisher::FixedContent::Ad.new(categories, options).sample_items }

    context 'カテゴリ1つで余裕がある場合' do
      let(:categories) { [has_4_ads_category] }
      it '3件' do
        expect(ads.size).to eq max_size
      end
    end

    context 'カテゴリ複数で単体カテゴリだと足りなくトータルで余裕がある場合' do
      let(:categories) { [has_2_ads_category1, has_2_ads_category2] }
      it '3件' do
        expect(ads.size).to eq max_size
      end
    end

    context '広告カテゴリが無い場合' do
      let(:categories) { [no_ads_category] }
      it '0件' do
        expect(ads.size).to eq 0
      end
    end

    context 'カテゴリ1つでMAXに満たない場合' do
      let(:categories) { [has_2_ads_category1] }
      it '2件' do
        expect(ads.size).to eq 2
      end
    end
  end

  describe '#format_body' do
    let(:categories) { [has_4_ads_category] }

    subject(:body) { HatenablogPublisher::FixedContent::Ad.new(categories, options).format_body }

    context 'htmlタイプの場合' do
      let(:ad_type) { 'html' }
      it 'iframeが閉じタグ含め6件出力されている' do
        expect(body.scan(/iframe/).size).to eq 6
      end
    end

    context 'imageタイプの場合' do
      let(:ad_type) { 'image' }
      it 'imageが3件出力されている' do
        expect(body.scan(/img/).size).to eq 3
      end
    end
  end
end
