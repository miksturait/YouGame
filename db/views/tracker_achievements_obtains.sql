select
tracker_members.id as member_id,
tracker_members.tracker_id,
tracker_points_obtains.subject_id as achievement_id,
count(tracker_points_obtains) as occurrences
from tracker_members
join tracker_points_obtains on tracker_points_obtains.member_id = tracker_members.id
where subject_type = 'Achievement'
group by tracker_members.id, tracker_members.tracker_id, tracker_points_obtains.subject_id