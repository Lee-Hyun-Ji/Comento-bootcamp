# 휴일을 제외한 로그인수 구현

### 1. Holidays테이블 생성 후, csv파일을 Holidays 테이블로 import
* 2018-2022 공휴일 정보 엑셀 파일 다운받기[(링크)](https://aspdotnet.tistory.com/2259)
* csv 파일 임포트 방법[(참고)](https://cotak.tistory.com/63)

 

### 2. SQL 쿼리 매핑
* 주말을 제외한 날짜, 로그인수 select
```sql
<select id="selectMonthLogin" parameterType="string" resultType="com.devfun.setting_boot.dto.LoginDateListDto">
		SELECT substr(info.createDate,5,2) AS logDate, count(left(info.createDate, 6)) AS logCnt
		FROM statistic.requestinfo info
		WHERE info.requestCode = 'L' AND left(info.createDate, 4) = #{month} AND dayofweek(left(info.createDate, 6)) between 2 and 6
		GROUP BY logDate
		ORDER BY logDate;
</select>
```

* 특정 월의 공휴일 일자 select
```sql
<select id="selectHoliday" parameterType="string" resultType="string">
		SELECT day(h.date) AS dayOfHoliday
		FROM statistic.holidays h
		WHERE right(year(h.date),2)=#{year} AND month(h.date)=#{month};
</select>
```



### 3. Service 클래스에서 공휴일을 제외한 총 로그인수 구하기
* StatisticServiceImpl.java[(코드)](https://github.com/Lee-Hyun-Ji/spring-web-setting/blob/main/settingweb_boot/src/main/java/com/devfun/setting_boot/service/StatisticServiceImpl.java)
```java
List<LoginDateListDto> weekdayLogins = mapper.selectMonthLogin(month);
List<String> holidays = mapper.selectHoliday(month.substring(0, 2), month.substring(2));
			
int logCnt = 0;
  for(LoginDateListDto dto: weekdayLogins) {
	  if(!holidays.contains(dto.getLogDate()))
	  logCnt += dto.getLogCnt();
```

 


# RequestParameter 날짜 형식 유효성 검사

### 1. 예외 처리를 위한 클래스 생성
* ErrorMessage.java
```java
public class ErrorMessage {
	private String errorCode;
	private String errorMessage;
	
	public ErrorMessage(String errorCode, String errorMessage) {
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}
	
	public String getCode() {
		return errorCode;
	}
	public void setCode(String errorCode) {
		this.errorCode = errorCode;
	}
	public String getMessage() {
		return errorMessage;
	}
	public void setMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}
```
* DateFormatException.java
```java
public class DateFormatException extends Exception{
	public DateFormatException(String date) {
		super("요청 변수가 잘못된 형식입니다(\'" + date + "\')");
	}
}
```

 


### 2. Service 클래스에서 유효성 검사 코드 구현
* StatisticServiceImpl.java[(코드)](https://github.com/Lee-Hyun-Ji/spring-web-setting/blob/main/settingweb_boot/src/main/java/com/devfun/setting_boot/service/StatisticServiceImpl.java)
```java
if(month.length() != 4)
  throw new DateFormatException(month);
for(int i = 0; i < 4; i++) {
  if(!Character.isDigit(month.charAt(i)))
    throw new DateFormatException(month);
}
```

 


### 3. Controller 클래스에서 @ExceptionHandler로 예외 처리
* StatisticApiController.java[(코드)](https://github.com/Lee-Hyun-Ji/spring-web-setting/blob/main/settingweb_boot/src/main/java/com/devfun/setting_boot/controller/StatisticApiController.java)
```java
@ExceptionHandler
	 public ErrorMessage illegalExHandle(DateFormatException e) {
        return new ErrorMessage("400", e.getMessage());
    }
```
* 예외 메시지 출력 화면
<img width="497" alt="잘못된 형식" src="https://user-images.githubusercontent.com/84483522/167138648-a7230824-7cf6-4df5-9be7-457ea183c578.PNG">
