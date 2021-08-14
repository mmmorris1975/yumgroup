# smart card group packages
control 'default' do
  title 'Default dial-up packages'

  %w(
    ppp
    ModemManager
    NetworkManager-adsl
    lrzsz
  ).each do |p|
    describe package p do
      it { should be_installed }
    end
  end
end
