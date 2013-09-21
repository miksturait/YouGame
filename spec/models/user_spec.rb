require 'spec_helper'

describe User do
  let!(:tracker){VCR.use_cassette('create tracker'){create(:tracker)}}
  subject{create(:user)}

  describe '#assign_tracker_member' do
    let!(:tracker_member){create(:tracker_member, tracker: tracker, email: subject.email)}

    it {expect{subject.assign_tracker_member}.to change{subject.tracker_member_id}}
  end

  context 'user assigned to tracker' do
    let!(:tracker_member){create(:tracker_member, user: subject, tracker: tracker)}

    describe '#update_activity_stamp' do
      it {expect{subject.update_activity_stamp}.to change{subject.tracker.last_user_activity_at}}
    end

    describe '#is_project_leader?' do
      context 'when is leader' do
        let!(:project){create(:tracker_project, tracker: tracker, lead_id: tracker_member.id)}

        it {expect(subject.is_project_leader?).to be_true}
      end
      context 'when is not leader' do
        let!(:project){create(:tracker_project, tracker: tracker, lead_id: 0)}

        it {expect(subject.is_project_leader?).to be_false}
      end
    end
  end
end
