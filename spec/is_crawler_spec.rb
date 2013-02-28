describe IsCrawler do
  let(:user_agent) { "Commodo Vestibulum/1.0" }
  describe '#is_any_crawler?' do
    subject { Test.new.is_any_crawler?(user_agent) }
    it 'defers to Crawler#matches_any?' do
      Crawler.should_receive(:matches_any?).with(user_agent)
      subject
    end
  end

  describe '#is_crawler?' do
    subject { Test.new.is_crawler?(user_agent, :facebook, :google) }
    context 'When the provided string matches a crawler' do
      context 'and it is in the specified list' do
        context 'as the first element' do
          let(:user_agent) { "facebookexternalhit/1.1" }
          it { should be_true }
        end

        context 'as a subsequent element' do
          let(:user_agent) { "Googlebot/1.1" }
          it { should be_true }
        end
      end

      context 'and it is not in the specified list' do
        let(:user_agent) { "Twitterbot/1.1" }
        it { should be_false }
      end
    end

    context 'When the provided string matches no crawlers' do
      it { should be_false }
    end
  end

  describe '#which_crawler' do
    subject { Test.new.which_crawler(user_agent) }
    context 'When the provided string matches a crawler' do
      let(:user_agent) { "facebookexternalhit/1.1" }
      its(:name) { should == :facebook }
    end

    context 'When the provided string matches no crawlers' do
      it { should be_nil }
    end
  end
end

class Test; include IsCrawler; end
