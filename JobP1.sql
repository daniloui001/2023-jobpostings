SELECT *
FROM 
	JobPostings..JobsNYCPostings
ORDER BY 
	2

-- None of the recruiters contacted? Let me double check that, seems there are more Internal posts rather than External posts as well

-- Some slight cleaning, should have done this within the excel file to be honest
EXEC sp_rename 'JobPostings..JobsNYCPostings."Agency"', 'Agency', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Posting Type"', 'PostingType', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."# Of Positions"', 'NumberOfPositions', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Business Title"', 'BusinessTitle', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Civil Service Title"', 'CivilServiceTitle', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Title Classification"', 'TitleClassification', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Job Category"', 'JobCategory', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Full-Time/Part-Time indicator"', 'FullTimePartTimeIndicator', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Career Level"', 'CareerLevel', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Salary Range From"', 'SalaryRangeFrom', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Salary Range To"', 'SalaryRangeTo', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Salary Frequency"', 'SalaryFrequency', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Work Location"', 'WorkLocation', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Division/Work Unit"', 'DivisionWorkUnit', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Minimum Qual Requirements"', 'MinimumQualRequirements', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Preferred Skills"', 'PreferredSkills', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Additional Information"', 'AdditionalInformation', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."To Apply"', 'ToApply', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Hours/Shift"', 'HoursShift', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Work Location 1"', 'WorkLocation1', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Recruitment Contact"', 'RecruitmentContact', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Residency Requirement"', 'ResidencyRequirement', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Posting Date"', 'PostingDate', 'COLUMN';
EXEC sp_rename 'JobPostings..JobsNYCPostings."Posting Updated"', 'PostingUpdated', 'COLUMN';

SELECT 
	RecruitmentContact, COUNT(*) AS RecruitersContact
FROM 
	JobPostings..JobsNYCPostings
GROUP BY 
	RecruitmentContact;

-- According to the data, no recruiters had contacted back, all of the values were NaN

SELECT 
	PostingType, COUNT(*) AS NumberOfPosts
FROM 
	JobPostings..JobsNYCPostings
GROUP BY 
	PostingType;

-- There are about 150 more posts for internal positions, 2728 vs. 2873

-- I want to know how many of the jobs have the term 'data' or 'analyst' in them

SELECT 
	COUNT(*) AS NumberOfJobs
FROM 
	JobPostings..JobsNYCPostings
WHERE 
	BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%';

-- There's around 513 jobs that may contain the term data or analyst in them

SELECT 
	PostingType, COUNT(*) AS NumberOfJobs
FROM 
	JobPostings..JobsNYCPostings
WHERE 
	BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%'
GROUP BY 
	PostingType;

-- 251 of those jobs are externally posted, 262 of them are internally posted

-- Let's also see if there's a difference between CivilServiceTitle and BusinessTitle

SELECT 
	COUNT(*) AS NumberOfJobs
FROM 
	JobPostings..JobsNYCPostings
WHERE 
	CivilServiceTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%';

-- There are less jobs actually! Only 406 jobs.

SELECT 
	PostingType, COUNT(*) AS NumberOfJobs
FROM 
	JobPostings..JobsNYCPostings
WHERE 
	CivilServiceTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%'
GROUP BY 
	PostingType;

-- Once again though, albeit 199 vs. 207, Internal jobs are higher

-- Understanding if Agency Plays A Role, I personally do not think so, but who knows

SELECT 
	Agency, COUNT(*) AS PostingsFromAgency
FROM 
	JobPostings..JobsNYCPostings
GROUP BY 
	Agency
ORDER BY 
	PostingsFromAgency DESC;

-- Maybe? 1007 jobs were from Dept of Environment, Dept of Hygeine is 872

SELECT 
    COUNT(*) AS NumberOfAgenciesWithMultiplePostings
FROM (
    SELECT 
        Agency
    FROM 
        JobPostings..JobsNYCPostings
    GROUP BY 
        Agency
    HAVING 
        COUNT(*) > 1
) AS MultiplePostingsAgencies;

-- 60/61 agencies have multiple postings 

-- Percentage of Agencies that are for Data/Analytics

SELECT 
	Agency, 
	COUNT(*) AS MultiplePostings,
	COUNT(*) * 100.0 / (SELECT COUNT(*) FROM JobPostings..JobsNYCPostings) AS Percentage
FROM 
	JobPostings..JobsNYCPostings
WHERE
	BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%'
GROUP BY
	Agency
ORDER BY 
	MultiplePostings DESC;

-- Following line is to double check my work, number should add up to 513

SELECT 
    Agency, 
    COUNT(*) AS MultiplePostings,
    (SELECT COUNT(*) 
     FROM JobPostings..JobsNYCPostings 
     WHERE BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%') AS TotalPostings,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM JobPostings..JobsNYCPostings WHERE BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%') AS Percentage
FROM 
    JobPostings..JobsNYCPostings
WHERE 
    BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%'
GROUP BY 
    Agency
ORDER BY 
    MultiplePostings DESC;

-- On the right track (thumbs up)

-- The Dept. of Health/Mental has most (1.84%)[103], but is followed by dept of social services (0.9998%)[56], transportation[53], and environment protection[43]

SELECT 
	FullTimePartTimeIndicator, COUNT(*) AS FullvsPart
FROM 
	JobPostings..JobsNYCPostings
GROUP BY 
	FullTimePartTimeIndicator;

-- 141 nulls, 5180 F, 280 P. Most of the jobs are Full-time positions

SELECT 
	FullTimePartTimeIndicator, 
	COUNT(*) AS RepeatingAgencies,
	COUNT(*) * 100.0 / (SELECT COUNT(*) FROM JobPostings..JobsNYCPostings) AS Percentage
FROM
	JobPostings..JobsNYCPostings
WHERE 
	BusinessTitle LIKE '%data%' OR BusinessTitle LIKE '%analyst%'
GROUP BY 
	FullTimePartTimeIndicator
ORDER BY RepeatingAgencies DESC;

SELECT 
	FullTimePartTimeIndicator, 
	COUNT(*) AS RepeatingAgencies,
	COUNT(*) * 100.0 / (SELECT COUNT(*) FROM JobPostings..JobsNYCPostings) AS Percentage
FROM 
	JobPostings..JobsNYCPostings
GROUP BY 
	FullTimePartTimeIndicator
ORDER BY 
	RepeatingAgencies DESC;

-- In general there are 5180 Repeating 

-- HoursShift and WorkLocation1 look really empty let me see

SELECT 
    COUNT(CASE WHEN HoursShift IS NOT NULL THEN 1 END) AS NonNulls,
    COUNT(CASE WHEN HoursShift IS NULL THEN 1 END) AS Nulls,
    COUNT(*) AS TotalCount,
    (COUNT(CASE WHEN HoursShift IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)) AS NonNullPercentage,
    (COUNT(CASE WHEN HoursShift IS NULL THEN 1 END) * 100.0 / COUNT(*)) AS NullPercentage
FROM 
    JobPostings..JobsNYCPostings;

-- 63% of this data is null, I do not really think working with HoursShift will give us any valuable data since most of the data is null, would ask questions in IRL situation

-- Now lets check WorkLocation1

SELECT 
    COUNT(CASE WHEN WorkLocation IS NOT NULL THEN 1 END) AS NonNulls,
    COUNT(CASE WHEN WorkLocation IS NULL THEN 1 END) AS Nulls,
    COUNT(*) AS TotalCount,
    (COUNT(CASE WHEN WorkLocation IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)) AS NonNullPercentage,
    (COUNT(CASE WHEN WorkLocation IS NULL THEN 1 END) * 100.0 / COUNT(*)) AS NullPercentage
FROM 
    JobPostings..JobsNYCPostings;

SELECT 
    COUNT(CASE WHEN WorkLocation1 IS NOT NULL THEN 1 END) AS NonNulls,
    COUNT(CASE WHEN WorkLocation1 IS NULL THEN 1 END) AS Nulls,
    COUNT(*) AS TotalCount,
    (COUNT(CASE WHEN WorkLocation1 IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)) AS NonNullPercentage,
    (COUNT(CASE WHEN WorkLocation1 IS NULL THEN 1 END) * 100.0 / COUNT(*)) AS NullPercentage
FROM 
    JobPostings..JobsNYCPostings;

-- Once again, 63% of data is missing from **WorkLoaction1**, WorkLocation has NO Nulls; safe to ignore WorkLocation1 and Hourshift for future analysis

-- Title Classification, lets us see the competitve/non-compettive jobs

SELECT TitleClassification,
	COUNT(*) AS Titles,
	COUNT(*) * 100.0/ (SELECT COUNT(*) FROM JobPostings..JobsNYCPostings) AS TitlesPercentage 
FROM 
	JobPostings..JobsNYCPostings
GROUP BY 
	TitleClassification
ORDER BY 
	Titles DESC;

-- 62% of jobs are competitive, 30% of them are non-competitve

-- Dates Posted, Find out when jobs are posted the most

SELECT 
    DATEPART(YEAR, PostingDate) AS PostingYear,
    DATEPART(MONTH, PostingDate) AS PostingMonth,
    COUNT(*) AS FrequencyOfPosts
FROM 
    JobPostings..JobsNYCPostings
GROUP BY 
    DATEPART(YEAR, PostingDate),
    DATEPART(MONTH, PostingDate)
ORDER BY
	FrequencyOfPosts DESC;

-- 712 Posts in 2024 January? This doesn't look all the way right..., October in 2023 there were 680 posts for jobs as well.
-- Actually this kind of makes sense, weren't there hiring freezes during 2023? That's why the number is so low until the end of the year
-- 9-12 there were tons of jobs posted in 2023

--CareerLevel
