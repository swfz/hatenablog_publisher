RSpec.describe HatenablogPublisher::Options do
  describe '.new' do
    let(:args) { {} }
    let(:options) { HatenablogPublisher::Options.new(args) }

    context '入力なし' do
       it '足りないキーを出力しraiseされるか' do
        expect { options.valid_or_raise }.to raise_error('Following keys are not setup. ["consumer_key", "consumer_secret", "access_token", "access_token_secret", "user", "site", "filename"]')
      end
    end

    context '必須オプション環境変数以外入力済み' do
      let(:args) do
        {
          filename: './spec/support/sample.md',
          user: 'hoge',
          site: 'fuga'
        }
      end

      it '足りないキーを出力しraiseされるか' do
        expect { options.valid_or_raise }.to raise_error('Following keys are not setup. ["consumer_key", "consumer_secret", "access_token", "access_token_secret"]')
      end
    end

    context '必須オプション入力済み' do
      let(:args) do
        {
          filename: './spec/support/sample.md',
          user: 'hoge',
          site: 'fuga',
          consumer_key: 'hoge',
          consumer_secret: 'hoge',
          access_token: 'hoge',
          access_token_secret: 'hoge'
        }
      end

      it 'HatenablogPublisher::Optionsのインスタンスが返ってくるか' do
        expect(options.valid_or_raise).to be_an_instance_of(HatenablogPublisher::Options)
      end

      it 'argsで渡ってきたものと同様である(user)' do
        expect(options.valid_or_raise.user).to eq(args[:user])
      end

      it 'argsで渡ってきたものと同様である(site)' do
        expect(options.valid_or_raise.site).to eq(args[:site])
      end

      it 'argsで渡ってきたものと同様である(filename)' do
        expect(options.valid_or_raise.filename).to eq(args[:filename])
      end
    end

    context '設定ファイルの読み込み' do
      let(:options) { HatenablogPublisher::Options.create(args) }
      let(:args) do
        {
          filename: './spec/support/sample.md',
          config: './spec/support/custom_config.yml',
          site: 'fuga',
          consumer_key: 'hoge',
          consumer_secret: 'hoge',
          access_token: 'hoge',
          access_token_secret: 'hoge'
        }
      end

      it '設定ファイルの値を呼んでいる(user)' do
        expect(options.valid_or_raise.user).to eq('user_from_config_file')
      end

      it '設定ファイルとコマンドライン引数両方存在する場合、コマンドライン引数の値を呼んでいる(site)' do
        expect(options.valid_or_raise.site).to eq('fuga')
      end
    end
  end
end
