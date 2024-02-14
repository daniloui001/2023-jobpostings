-- Slight Cleaning, want to make things much more clearer, I have a backup saved on Excel. Also the backup is in github

SELECT
	*
FROM 
	JobPostings..JobsNYCPostings

-- Dropping RecruitmentContact since there's no data in that at all

ALTER TABLE JobPostings..JobsNYCPostings
DROP COLUMN RecruitmentContact

-- Dropping ResidencyRequirement because I don't think I need that

ALTER TABLE JobPostings..JobsNYCPostings
DROP COLUMN ResidencyRequirement

-- Dropping ToApply, there's no reason to keep that, the data is not usable for me due to variance and nonsensicalness

ALTER TABLE JobPostings..JobsNYCPostings
DROP COLUMN ToApply

-- Dropping AdditionalInformation

ALTER TABLE JobPostings..JobsNYCPostings
DROP COLUMN AdditionalInformation

-- Dropping PreferredSkills

ALTER TABLE JobPostings..JobsNYCPostings
DROP COLUMN PreferredSkills

-- Considering removing values that are Pre 2023, since I did find some data points

SELECT 
	PostingDate
FROM 
	JobPostings..JobsNYCPostings
WHERE
	YEAR(PostingDate) < 2023;

-- There are 768 Postings that are from 2022 and before... May just delete them since this is JUST about 2023, I maybe I will use 2022 data and connect them later

DELETE FROM JobPostings..JobsNYCPostings
WHERE YEAR(PostingDate) < 2023;

-- Curious about PostingUpdated, forgot to check before

SELECT
	PostingUpdated
FROM 
	JobPostings..JobsNYCPostings
WHERE 
	YEAR(PostingUpdated) < 2024

SELECT
	COUNT(PostingUpdated) AS Posts
FROM 
	JobPostings..JobsNYCPostings
WHERE 
	PostingDate = PostingUpdated

-- 2831 Posts/4833 Posts

ALTER TABLE JobPostings..JobsNYCPostings
DROP COLUMN WorkLocation1