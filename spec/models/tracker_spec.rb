require 'spec_helper'

describe Tracker do
  subject{VCR.use_cassette('create tracker'){create(:tracker)}}

  describe '#visible_members' do
    let!(:tracker_member){create(:tracker_member, tracker: subject)}
    let!(:other_member){create(:tracker_member, tracker: subject)}
    before {subject.hidden_member_ids = [other_member.id]}

    it {expect(subject.visible_members).to have(1).tracker_member}
  end

  describe '#mailable_members' do
    let!(:tracker_member){create(:tracker_member, tracker: subject, user: create(:user))}
    let!(:other_member){create(:tracker_member, tracker: subject, user: create(:user, receive_emails: false))}

    it {expect(subject.mailable_members).to have(1).tracker_member}
  end

  describe '#list_of_accepted_states' do
    before{ subject.issue_accepted_state = 'it is ok, well done' }

    it {expect(subject.list_of_accepted_states).to eql ['it is ok', 'well done']}
  end

  describe '#list_of_in_progress_states' do
    before{ subject.issue_in_progress_state = 'I am doing it, in progress' }

    it {expect(subject.list_of_in_progress_states).to eql ['I am doing it', 'in progress']}
  end

  describe '#list_of_backlog_states' do
    before{ subject.issue_backlog_state = 'backlog, to do' }

    it {expect(subject.list_of_backlog_states).to eql ['backlog', 'to do']}
  end

  describe '#generate_api_key!' do
    it {expect{subject.generate_api_key!}.to change{subject.api_key}}
  end
end
