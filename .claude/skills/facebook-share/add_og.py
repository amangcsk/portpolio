"""HTML 파일에 페이스북 미리보기(Open Graph) 설정을 넣고, 책 속 첫 그림을 표지로 저장한다.

사용법:  python -I add_og.py "storyboard/새책.html" ["stories/Middle/또다른책.html" ...]
- 경로는 포트폴리오 폴더(D:\\claude\\portpolio) 기준 상대 경로 또는 절대 경로
- 이미 og 설정이 있는 파일은 건너뛴다
- 마지막에 공유용 주소를 한 줄씩 출력한다:  URL<TAB>파일
"""
import re, sys, base64, struct, html
from pathlib import Path
from urllib.parse import quote

ROOT = Path(r"D:\claude\portpolio")
BASE = "https://amangcsk.github.io/portpolio/"
SITE = "나의 작품 전시관"

IMG = re.compile(rb'data:image/(?:webp|jpeg|png);base64,([A-Za-z0-9+/=]{4000,})')
TITLE = re.compile(rb'<title>(.*?)</title>', re.S)


def img_info(b):
    """(확장자, 가로, 세로) — 모르면 None"""
    if b[:4] == b"RIFF" and b[8:12] == b"WEBP":
        if b[12:16] == b"VP8 ":
            w, h = struct.unpack("<HH", b[26:30]); return "webp", w & 0x3fff, h & 0x3fff
        if b[12:16] == b"VP8X":
            return "webp", 1 + int.from_bytes(b[24:27], "little"), 1 + int.from_bytes(b[27:30], "little")
        return "webp", None, None
    if b[:8] == b"\x89PNG\r\n\x1a\n":
        return "png", *struct.unpack(">II", b[16:24])
    if b[:2] == b"\xff\xd8":
        return "jpg", None, None
    return None


def process(f: Path):
    raw = f.read_bytes()
    rel = f.relative_to(ROOT).as_posix()
    url = BASE + quote(rel)
    if b"og:image" in raw or b"og:title" in raw:
        return url, "이미 설정됨"
    m = TITLE.search(raw)
    if not m:
        return None, "<title>이 없어 건너뜀"
    title = m.group(1).decode("utf-8").strip()
    desc = f"그림과 글로 읽는 이야기책 | {SITE}"
    cover = None
    im = IMG.search(raw)
    if im:
        b = base64.b64decode(im.group(1))
        info = img_info(b)
        if info:
            ext, w, h = info
            cover_rel = f"_thumbs/{f.stem}_cover.{ext}"
            (ROOT / cover_rel).write_bytes(b)
            cover = (cover_rel, w, h)
    nl = b"\r\n" if b"\r\n" in raw[:3000] else b"\n"
    lines = [
        f'<meta name="description" content="{html.escape(desc)}">',
        '<meta property="og:type" content="article">',
        f'<meta property="og:title" content="{html.escape(title)}">',
        f'<meta property="og:description" content="{html.escape(desc)}">',
        f'<meta property="og:url" content="{url}">',
    ]
    if cover:
        lines.append(f'<meta property="og:image" content="{BASE + quote(cover[0])}">')
        if cover[1]:
            lines += [f'<meta property="og:image:width" content="{cover[1]}">',
                      f'<meta property="og:image:height" content="{cover[2]}">']
        lines.append('<meta name="twitter:card" content="summary_large_image">')
    ins = nl + nl.join(("  " + l).encode("utf-8") for l in lines)
    f.write_bytes(raw[:m.end()] + ins + raw[m.end():])
    return url, "설정 추가" + (f" + 표지 {cover[0]}" if cover else " (책 안에 그림이 없어 글자만 미리보기)")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    for a in sys.argv[1:]:
        p = Path(a)
        p = p if p.is_absolute() else ROOT / p
        if not p.is_file():
            print(f"!\t{a}\t파일을 찾을 수 없음"); continue
        try:
            url, note = process(p.resolve())
        except Exception as e:
            print(f"!\t{a}\t오류: {e}"); continue
        print(f"{url}\t{a}\t{note}")
