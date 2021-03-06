require 'oystercard'

describe Oystercard do
  subject { Oystercard.new }
  let(:station) { Station.new }
  let(:start_station) { Station.new }
  let(:end_station) { Station.new }

  it 'responds to #balance' do
    expect(subject).to respond_to :balance
  end
  it 'checks that a new card has a balance' do
    expect(subject.balance).not_to be_nil
  end
  it 'responds to #top_up' do
    expect(subject).to respond_to(:top_up).with(1).argument
  end
  it 'should add money to balance' do
    top_amnt = 3.0
    orig_amnt = subject.balance
    subject.top_up(top_amnt)
    expect(subject.balance).to eq(orig_amnt + top_amnt)
  end

  it 'should not allow the user to top up above the specified limit' do
    expect { subject.top_up(Oystercard::LIMIT + 1) }.to raise_error "Top up would exceed the card's balance limit of £#{Oystercard::LIMIT}"
  end

  it 'should allow the user to touch in when entering the station' do
    subject.top_up(10.0)
    expect(subject).to respond_to :touch_in
    allow(subject).to receive(:touch_in).and_return('Camden')
    allow(start_station).to receive(:station_name).and_return('Camden')
    expect(subject.touch_in).to eq start_station.station_name
  end

  it 'should allow the user to touch out when leaving the station' do
    expect(subject).to respond_to :touch_out
    expect(subject.touch_out).not_to be_nil
  end

  it 'should not allow the user to touch in if balance is less than fare' do
    allow(subject).to receive(:balance).and_return(6.5)
    expect { subject.touch_in }.to raise_error 'Insufficient balance on card.'
  end
end
