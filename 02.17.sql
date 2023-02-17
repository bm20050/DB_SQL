-- 국가 코드가 'KOR'인 도시를 찾아 인구수를 역순으로 표시하시오.
select name, population
from city
where countrycode='KOR'
order by population desc;

-- city 테이블에서 국가코드와 인구수를 출력하라. 정렬은 국가 코드별로 오름차순으로, 동일한 코드(국가) 안에서는 인구 수의 역순으로 표시하라.
select countrycode, population
from city
order by CountryCode asc, population desc;

-- city 테이블에서 국가코드가 'KOR', 'CHN', 'JPN'인 도시를 찾으시오.
select name, CountryCode
from city
where CountryCode in ('KOR', 'CHN', 'JPN');

-- 국가 코드가 'KOR'이면서 인구가 100만 이상인 도시를 찾으시오.
select name, population
from city
where CountryCode = 'KOR' and population > 1000000;

-- 국가 코드가 'KOR'인 도시 중 인구수가 많은 순서로 상위 10개만 표시하시오.
select name, countrycode, population
from city
where countrycode = 'KOR'
order by population desc
limit 10;

-- city 테이블에서 국가코드가 'KOR'이고, 인구가 100만 이상 500만 이하의 도시를 찾으시오.
select name, countrycode, population
from city
where CountryCode = 'KOR' and Population between 1000000 and 5000000;