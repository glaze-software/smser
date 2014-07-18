describe Smser do
  before do
    Smser.configuration = Smser::Configuration.new
  end

  it do
    Smser.configure do |config|
      config.default_adapter = :some

      config.adapters.some.tap do |adapter|
        adapter.login = 1
        adapter.password = 2

        adapter.settings.url = 'url'
        adapter.settings.text_code = :txt
        adapter.settings.phone_code = :phone
      end
    end

    expect(Smser::Sms).to receive(:pass).with('text', 'qwe', {settings: {url: 'url', text_code: :txt, phone_code: :phone}, login: 1, password: 2})

    Smser.pass 'text', 'qwe'
  end

  describe Smser::Sms do
    before do
      @adapter_params = {settings: {url: 'url', text_code: :txt, phone_code: :phone}, login: 1, password: 2}
    end

    describe '.pass' do
      it do
        allow(Smser::Sms).to receive(:URI).with(@adapter_params[:settings][:url]).and_return(:uri)

        expect(Net::HTTP).to receive(:post_form).with(:uri, {login: 1, password: 2, txt: 'text', phone: 'phone'})

        Smser::Sms.pass 'text', 'phone', @adapter_params
      end
    end
  end
end