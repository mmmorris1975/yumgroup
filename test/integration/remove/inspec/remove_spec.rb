control 'default' do
  title 'Default fonts packages (should be removed)'

  %w(
    dejavu-sans-mono-fonts
    dejavu-serif-fonts
    gnu-free-mono-fonts
    gnu-free-sans-fonts
    gnu-free-serif-fonts
  ).each do |p|
    describe package p do
      it { should_not be_installed }
    end
  end
end
