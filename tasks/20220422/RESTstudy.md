# [2주차 과제]Rest API 학습
> *목차*
> - [*HTTP 통신*](#HTTP-통신)
> - [*브라우저의 동작과정*](#브라우저의-동작-과정)
> - [*Rest API*](#Rest-API)
 
  
 
## HTTP 통신

### 개념
HTTP(Hyper Text Transfer Protocol)란 웹 통신을 위한 응용계층 프로토콜을 의미하며, TCP/IP 통신(전송계층) 위에서 동작한다. 
HTTP는 서버로부터 웹 표준 데이터(HTML, CSS, JS 등)를 받아오기 위해 사용되는 규약이다.

 


### 특징
**1. Server-Client 구조**  
 : Client에서 request를 보내면, Server에서 이에 대한 response를 전송하도록 설계되었다.


**2. URI**      
 : HTTP 프로토콜은 URI를 통해 요청하는 리소스를 지정한다.


**3. Stateless(무상태성)**  
 : 서버가 클라이언트의 요청에 대한 상태 정보를 유지하거나 보관하지 않고, 연결을 끊는다.  
 따라서 서버측에서는 클라이언트의 이전 상태를 알 수 없기 때문에, Cookie 또는 Session등을 통해 이러한 문제를 해결한다.   
 또한, HTTP/1.1부터는 keep-alive-mechanism을 지원하여, 일정 시간동안 connection을 유지시켜준다.
 
 
  
 
 ### HTTP 패킷
 : HTTP 통신은 요청을 보내거나(Request Message) 응답을 보낼 때(Response Message), 관련 정보들을 패킷(packet)에 담아 보낸다.  
 패킷은 크게 start-line, Header, empty line, Body로 나눠져있다.
- start-line: 요청 메서드, HTTP 버전 정보, 응답 결과
- Header: 송수신자의 주소, 패킷 생명시간, 요청에 대한 설명 등 메타 정보
- empty line: Header에서 모든 메타 정보가 전송되었음을 알리는 빈 줄
- Body: 실제 전달하고자 하는 내용

![HTTPMsgStructure2](https://user-images.githubusercontent.com/84483522/164592514-327f831d-1533-4511-96cc-40e19b1df436.png)
 
 
  
 
 ### Request  Method
 : HTTP는 메서드를 통해 특정 자원에 대한 일정한 행위를 요청할 수 있다. 즉 HTTP method는 요청 행위를 지정하는 것으로, Requset message의 start-line에 포함되어 있다. HTTP 프로토콜에서는 다음과 같은 메서드들을 지원하고 있다.

- GET - 리소스 요청(Select)
- POST - 리소스 생성(Insert)
- PUT - 리소스 수정(Update)
- DELETE - 리소스 삭제(Delete)
- OPTIONS - 웹 서버가 지원하는 메서드의 종류를 요청
- HEAD - HTTP의 헤더 정보만 요청(해당 자원이 존재하는지 혹은 서버에 문제가 없는지 확인하는 용도)

 
  
 
> *참고  
> Wikipedia - HTTP: https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol  
> MDN docs: https://developer.mozilla.org/ko/docs/Web/HTTP  
> [REST API] OSI 7 계층 / HTTP 프로토콜: https://arclab.tistory.com/120  
> [네트워크] HTTP와 HTTPS 동작 과정: https://velog.io/@averycode/네트워크-HTTP와-HTTPS-동작-과정*
------------
 
  
 ## 브라우저의 동작 과정
 *(⇒ 브라우저에 URL 입력을 통한 요청 후, 서버에서 응답하는 과정)*
 
  ### 1.브라우저의 url 파싱
 주소창에서 도메인 네임만 작성한 경우, 브라우저에서 Protocol(HTTP or HTTPS)과 Port번호를 자동으로 세팅한다.  
ex) www.naver.com → https://www.naver.com:443

 
  
 
 ### 2.url을 IP주소로 변환
 2-1) DNS 캐시 기록 확인

- DNS 캐시: OS에서 관리하는 임시 데이터베이스로, 최근 방문한 기록 및 웹 사이트, 도메인에 관란 정보를 가지고 있음
- DNS 캐시에 해당 url에 관한 정보가 있으면 바로 사용

2-2) DNS 서버에서 IP 주소 검색

- DNS 서버: DNS와 IP 주소 정보가 저장된 데이터 베이스
- url 캐시가 존재하지 않을 경우, DNS 서버에 해당 도메인 네임에 매핑된 IP주소를 요청함

 
  
 ### 3. HTTP 요청 메시지 생성
 : DNS서버로부터 전달받은 IP주소를 사용하여 HTTP 요청 메시지를 생성한다.

 
  
 ### 4. TCP 연결(3-way handshake)
 : TCP 연결 과정(3-way handshake)을 거치고, TCP프로토콜을 통해 해당 IP주소의 컴퓨터로 TCP패킷을 전송한다.
 
  
 
 ### 5. 서버 컴퓨터에서 요청 메시지 확인
 : 요청 메시지는 HTTP 프로토콜을 사용하여 다시 웹 페이지 URL 정보로 변환된다.  
 웹 서버에서는 도착한 웹페이지의 URL정보에 해당하는 데이터를 검색한다.
  
  
 
 ### 6. HTTP 응답 메시지 생성 및 전송
 : 서버 측에서 응답할 데이터를 다시 HTTP 프로토콜을 사용하여 응답 메시지를 생성한다.
응답 메시지는 또한 TCP 프로토콜을 통해 클라이언트 컴퓨터로 전송된다.
 
  
 
 ### 7. 웹 브라우저에서 응답 메시지 해석 후 출력
 : 클라이언트 컴퓨터로 도착한 응답 메시지는 HTTP 프로토콜을 사용하여 웹 페이지 데이터로 변환된다.
변환된 웹 페이지 데이터는 웹 브라우저를 통해 해석되어 화면에 출력된다.
 
  
 
> *참고  
> TCP School - 웹의 동작 원리: http://tcpschool.com/webbasic/works  
> 웹 브라우저에 URL을 입력했을 때 발생하는 일: https://sorjfkrh5078.tistory.com/65  
> 브라우저는 어떻게 동작하는가?: https://d2.naver.com/helloworld/59361  
> [네트워크] HTTP와 HTTPS 동작 과정: https://velog.io/@averycode/네트워크-HTTP와-HTTPS-동작-과정*
 ------------
  
 
 ##  Rest API
 
 ### REST (Repreaentational State Transfer)
 : 자원을 ‘이름(자원의 표현)’으로 구분하고 해당 ‘자원의 상태’를 주고 받는 것을 의미한다. 구체적으로는 URI를 통해 자원을 표현하고, HTTP Method를 이용하여 자원에 관한 행위를 규정하도록 하는 아키텍처 스타일을 의미한다. 이는 HTTP를 기반으로 하여 HTTP를 본래 의미에 맞게 정석적으로 사용함으로써 웹의 장점을 최대한 활용하기 위해 고안되었다.
 
  
 
 ### REST 구성요소
1. **자원(Resource)**  
 - DB에 저장된 데이터뿐만 아니라, 이미지, 동영상, 문서 등과 같은 파일을 포함하는 개념  
 - REST에서는 자원에 접근하기 위해 URI를 사용한다.
2. **행위(Verb)**  
 - 클라이언트는 URI를 통해 자원을 지정하고, 자원을 조작하기 위해 HTTP Method(GET, POST..)를 사용한다.  
 - 따라서 클라이언트가 자원에 대한 행위를 특정하기 위해 url을 사용하면 안된다.
3. **표현(Representation)**  
 - 클라이언트와 서버가 데이터를 주고받는 형태를 의미한다.  
 - 주로 JSON, XML이 사용된다.
 
  
 
 ### REST 특징
 - **클라이언트-서버(Client-Server)구조**  
 : HTTP의 클라이언트-서버 아키텍처 스타일을 따른다.
- **무상태성(Stateless)**  
 : 클라이언트의 애플리케이션 상태를 서버에서 관리하지 않는다.
- **캐시 처리 가능(Cashable)**  
 : 대용량 요청을 효율적으로 처리하기 위해 캐시를 사용할 수 있다.
- **인터페이스 일관성(Uniform Interface)**  
 : URI로 지정한 리소스에 대한 조작을 통일되고 한정적인 인터페이스(HTTP Method)로 수행한다.
- **계층화(Layered System)**  
 : 시스템 전체를 계층화하기 쉽다. 예를 들어, 서버와 클라이언트 간의 로드밸런서를 설치해 부하를 분산시키거나, 프록시를 설치해 엑세스를 제어할 경우,  각 컴포넌트 간의 인터페이스를 HTTP로 통일하고 있기 때문에 계층을 분리하는 데 유리하다.
 
  
 
### REST의 장단점
[장점]

- HTTP인프라를 그대로 사용하므로, 별도의 인프라를 구축할 필요가 없다.
- HTTP 프로토콜을 따르는 모든 플랫폼에서 사용 가능하다.
- 서버와 클라이언트의 역할을 명확하게 분리한다.

[단점]

- 표준이 존재하지 않는다.
- 사용할 수 있는 메서드가 제한적이다.
 
  
 
### RESTful

: REST의 원리를 따르는 시스템을  RESTful하다고 표현하며, REST API를 제공하는 웹 서비스들은 RESTful하다고 할 수 있다. RESTful API를 구현하는 목적은 일관적인 형태를 사용하여 API의 호환성을 높이기 위해서이다. 다만, RESTful은 REST를 REST답게 사용하기 위한 방법일뿐, 공식적인 가이드는 아니다.
 
  
### REST API 가이드

1. URI는 자원만을 표현해야 한다.  ex)/getmovies(x) → /movies(o)
2. 자원에 대한 행위는 HTTP Method로 표현한다.
3. URI는 슬래시(/)로 계층 관계를 표현한다.  ex)/movies/inception
4. URI의 마지막에 슬래시(/)를 포함하지 않는다.
5. URI는 밑줄(_)을 사용하지 않고, 하이픈(-)을 사용한다.
6. URI는 소문자로만 구성한다.
7. 파일 확장자는 URI에 포함하지 않는다. ex)/movie/photo.jpg(x)
 
  
 
> *참고  
> gabia라이브러리 - RESTFUL API 설계 가이드: https://library.gabia.com/contents/8339/  
> gabia라이브러리 - RESTFUL API 설계 가이드: https://library.gabia.com/contents/8339/  
> RESTful API 이란: https://velog.io/@somday/RESTful-API-이란#rest-api  
> REST란: https://hckcksrl.medium.com/rest란-c602c3324196  
> REST란? REST API 와 RESTful API의 차이점: https://dev-coco.tistory.com/97  
> [네트워크 REST API란 REST RESTful이란]:  https://khj93.tistory.com/entry/네트워크-REST-API란-REST-RESTful이란  
>  RESTful API 설계 가이드: https://sanghaklee.tistory.com/57*
 
  
