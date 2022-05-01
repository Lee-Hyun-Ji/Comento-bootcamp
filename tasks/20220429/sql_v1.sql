-- 1. 월별 전체 접속자수
SELECT count(*) AS totCnt
FROM statistic.requestinfo AS info
WHERE left(info.createDate, 4) = #{month};
        
        
-- 2. 일별 전체 접속자수
SELECT count(*) AS totCnt
FROM statistic.requestinfo AS info
WHERE left(info.createDate, 6) = #{day};


-- 3. 부서별 월별 로그인수
SELECT count(*) AS logCnt
FROM statistic.requestinfo AS info LEFT OUTER JOIN statistic.user user
ON info.userID = user.userID
WHERE info.requestCode = 'L' AND user.HR_ORGAN = #{dept} AND left(info.createDate,4) = #{month};


-- 4. 평균 하루 로그인수
SELECT round(sum(sub.logCnt)/(datediff(DATE_FORMAT(#{endDate},'%Y-%m-%d'), DATE_FORMAT(#{startDate},'%Y-%m-%d'))+1),3) AS logAvg
FROM(
		SELECT left(info.createDate,6) AS logDate, count(*) AS logCnt
        FROM statistic.requestinfo info
        WHERE info.requestCode = 'L' AND left(info.createDate,6) BETWEEN #{startDate} AND #{endDate}
        group by left(info.createDate,6)
) AS sub;


-- 5. 휴일을 제외한 로그인수(로그인 날짜와 로그인수 select)
SELECT left(info.createDate, 6) AS logDate, count(left(info.createDate, 6)) AS logCnt
FROM statistic.requestinfo AS info
WHERE info.requestCode = 'L' AND left(info.createDate, 4) = #{month}
GROUP BY logDate
ORDER BY logDate;
