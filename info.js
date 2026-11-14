/* =====================================================================
   info.js  -  제목·설명을 직접 쓰고 싶을 때만 고치는 파일 (안 고쳐도 됩니다)
   =====================================================================
   ■ 아무것도 안 적으면 : 파일 이름이 제목이 되고, 설명은 비어 있습니다.
   ■ 메모장으로 열어 따옴표 " " 안의 글자만 고치세요.
     (따옴표, 쉼표, 중괄호 { } 는 지우지 마세요!)
   ■ 폴더 안내 :  gallery(그림·mp4·mp3·html·pdf 등 여러 파일)  /  musicvideos(뮤직 비디오 mp4만)
                  audios(음악)  /  storyboard(스토리북)  /  apps(앱)  /  stories(글 txt)
                  study(공부·참고 자료: txt·md·pdf·한글·워드·그림 등 아무거나)
   ■ 파일 이름은 폴더 이름부터 정확히 적어야 합니다.
     (예: "gallery/1.png")
   ■ 쓸 수 있는 칸 (모두 선택사항, 안 쓸 칸은 줄째 지워도 됩니다)
        title        제목
        description  한 줄 설명
        date         날짜 (예: "2026-10-29")
        cover        표지 그림 파일 (음악·스토리북·앱 카드에 사용, 예: "gallery/표지.webp")
        poster       영상 표지 그림 (안 쓰면 영상의 첫 장면이 나옵니다)
        order        순서 번호 (작은 숫자가 먼저. 안 쓰면 최근 파일이 먼저)
        hidden       true 라고 쓰면 전시하지 않고 숨깁니다
        tags         꼬리표(분류용 이름표). 예: tags: ["트롯", "손주"]  → 왼쪽 사이드바의 "꼬리표"에 모입니다
        collection   묶음 이름. 안 쓰면 폴더 안의 하위 폴더 이름이 자동으로 묶음이 됩니다
        youtube      유튜브 주소 (예: "https://youtu.be/abcdEFGhijk"). 인터넷에 게시했을 때
                     이 주소로 영상이 재생됩니다. 안 적은 영상은 올려 둔 파일로 재생됩니다.
   ■ 파일 칸에는 인터넷 주소나 Base64 코드도 쓸 수 있습니다.
   ===================================================================== */

/* ① 사이트 맨 위 인사말 */
window.SITE_INFO = {
  name:    "나의 작품 전시관",                            // 맨 위 큰 제목
  tagline: "그림 · 글 · 영상 · 음악, 삶을 담은 기록",       // 제목 아래 한 줄
  about:   "오랜 세월 마음에 담아 두었던 이야기를\n하나씩 꺼내어 이곳에 걸어 둡니다.", // \n 은 줄바꿈
  footer:  "© 2026 나의 작품 전시관 · 모든 작품의 저작권은 작가에게 있습니다.",
  contact: "문의 : sungkwancho@gmail.com"
};

/* ② 작품별 제목·설명 (원하는 작품만 적으세요) */
window.ARTWORK_INFO = {

  "gallery/1.png": {
    title: "",
    description: ""
  },

  "audios/🎤 〈불꽃처럼 달려간다〉-디스코 .mp3": {
    title: "불꽃처럼 달려간다 (디스코)",
    description: ""
  },

  "musicvideos/그대는 내 운명-최종.mp4": {
    title: "그대는 내 운명",
    description: "",
    youtube: "https://youtu.be/V9D1NAwgQCw"
  },

  "storyboard/1984_storybook.html": {
    title: "1984 스토리북",
    description: "조지 오웰 원작 그림 이야기책 (20장면 완결판)"
  },

  "storyboard/little_prince_storybook_standalone.html": {
    title: "어린 왕자 스토리북",
    description: "그림과 함께 읽는 이야기책"
  },

  "apps/수노분석영상스튜디오.html": {
    title: "수노 분석 영상 스튜디오",
    description: "음원을 분석해 Suno 스타일·가사를 만들고, 장면 이미지와 가사 영상(MP4)까지 제작 (Gemini 키 필요)",
    date: "2026-11-14"
  },

  "apps/Lyric-Video-Studio.html": {
    title: "가사 영상 스튜디오",
    description: "노래 가사 영상을 만드는 도구"
  },

  "musicvideos/꺼진 블씨를 잡고.mp4": {
    title: "",
    description: "",
    youtube: "https://youtu.be/2Nj-OAC73mw"
  },

  "musicvideos/물 흐르는대로-최종.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  "musicvideos/불꽃처럼 달려간다.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  "musicvideos/서울이여 안녕.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  "musicvideos/소매 끝 미소.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  "musicvideos/어둑한 골목 끝에.mp4": {
    title: "",
    description: "",
    youtube: "https://youtu.be/Xsqxk-wwitk"
  },

  "musicvideos/오늘은 주인공.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  "musicvideos/오지 않을 길목.mp4": {
    title: "",
    description: "",
    youtube: "https://youtu.be/eXZtFEb9WWc"
  },

  "musicvideos/저물어가는 노을 바라보며.mp4": {
    title: "",
    description: "",
    youtube: "https://youtu.be/Bm4V152HixQ"
  },

  "musicvideos/젊은 날의 사랑.mp4": {
    title: "",
    description: "",
    youtube: "https://youtu.be/LtkXO2gZsew"
  },

  "musicvideos/컴에 미쳐서.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  "musicvideos/타올라라, 나의 청춘": {
    title: "",
    description: "",
    youtube: "https://youtu.be/8nVkUN1KvoE"
  },

  "musicvideos/한이 불이 되어.mp4": {
    title: "",
    description: "",
    youtube: "https://youtu.be/xZ-XK4TRslg"
  },

  "musicvideos/Tears on the Horizon.mp4": {
    title: "Tears on the Horizon",
    description: "",
    youtube: "https://youtu.be/8l2DVuCpT-w"
  },

  "musicvideos/눈물의 항구.mp4": {
    title: "눈물의 항구",
    description: "",
    youtube: "https://youtu.be/xcYEyJxpAxI"
  },

  "musicvideos/시간이 멈춘 언덕에서.mp4": {
    title: "시간이 멈춘 언덕에서",
    description: "",
    youtube: "https://youtu.be/XuVE4ryT7mc"
  },

  "musicvideos/group perfomance.mp4": {
    title: "",
    description: "",
    youtube: ""
  },

  /* 아래는 위의 "젊은 날의 사랑.mp4"와 크기가 똑같아 같은 영상으로 보여 숨겨 두었습니다. 다른 영상이면 hidden 줄을 지우세요. */
  "musicvideos/mangajoa - 젊은 날의 사랑-6m40k5.mp4": {
    hidden: true
  }

};

/* ③ 파일 없이 유튜브 주소만으로 올리는 영상 (100MB 넘는 큰 뮤직 비디오는 여기에 적으세요)
   - 큰 영상 파일은 유튜브에 올리고, 아래처럼 한 덩어리씩 적으면 사이트에 카드가 생깁니다.
   - 쓸 수 있는 칸 : title(제목) description(설명) date(날짜) youtube(유튜브 주소)
                      poster(표지 그림, 안 쓰면 유튜브 표지) order(순서 번호) hidden(true 면 숨김)
   - 아래 덩어리를 복사해 붙여서 늘리세요. 덩어리 사이에는 쉼표(,)가 있어야 합니다.
   - category 를 "gallery" 로 바꾸면 뮤직 비디오가 아니라 갤러리에 나옵니다. */
window.EXTRA_WORKS = [

  {
    title: "타올라라, 나의 청춘",
    description: "",
    youtube: "https://youtu.be/8nVkUN1KvoE",
    order: 10
  },

  {
    title: "오지 않을 길목",
    description: "",
    youtube: "https://youtu.be/eXZtFEb9WWc",
    order: 20
  },

  {
    title: "오늘은 주인공",
    description: "",
    youtube: "https://youtu.be/IznWsxRuyCA",
    order: 30
  },

  {
    title: "어둑한 골목 끝에",
    description: "",
    youtube: "https://youtu.be/Xsqxk-wwitk",
    order: 50
  },

  {
    title: "물 흐르는대로",
    description: "",
    youtube: "https://youtu.be/yyjbZbPdqJI",
    order: 60
  },

  {
    title: "동백꽃 지던 밤",
    description: "",
    youtube: "https://youtu.be/3IvAkWLsfJk",
    order: 70
  },

  {
    title: "달빛 풍류가",
    description: "",
    youtube: "https://youtu.be/PEh7lUbi908",
    order: 80
  },

  {
    title: "내 사랑 당신",
    description: "",
    youtube: "https://youtu.be/pp73TDtKMzw",
    order: 90
  },

  // ▼ 예시입니다. 영상을 더 추가하려면 위의 덩어리를 복사해서 붙이세요.
  // {
  //   title: "제목",
  //   description: "",
  //   date: "2026-10-01",
  //   youtube: "https://youtu.be/영상번호11자리"
  // },

];
