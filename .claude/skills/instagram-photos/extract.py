"""책(HTML) 안의 그림을 인스타그램용 1080x1080 JPG 사진으로 뽑는다.

사용법:  python -I extract.py "storyboard/새책.html" [최대장수]
- 결과 폴더: D:\\claude\\instagram-photos\\<책 파일 이름>\\01.jpg, 02.jpg ...
  (포트폴리오 폴더 밖이라 GitHub에 올라가거나 '폴더 구조'에 보이지 않는다)
- 가운데를 정사각형으로 자르고 1080x1080으로 맞춘다 (ffmpeg 사용)
- 인스타그램은 한 게시물에 최대 20장 → 기본 최대 20장. 더 있으면 앞에서부터 고르게 20장을 뽑는다.
"""
import re, sys, base64, hashlib, subprocess, shutil
from pathlib import Path

ROOT = Path(r"D:\claude\portpolio")
OUT_ROOT = Path(r"D:\claude\instagram-photos")
IMG = re.compile(rb'(?:"([^"\\]{1,60})"\s*:\s*)?"data:image/(?:webp|jpeg|png);base64,([A-Za-z0-9+/=]{4000,})')


def natural(s):
    return [int(t) if t.isdigit() else t for t in re.split(r"(\d+)", s)]


def find_images(raw):
    found, seen = [], set()
    for m in IMG.finditer(raw):
        data = m.group(2)
        h = hashlib.md5(data).hexdigest()
        if h in seen:
            continue
        seen.add(h)
        found.append((m.group(1).decode("utf-8", "ignore") if m.group(1) else None, data))
    keys = [k for k, _ in found]
    if found and all(keys) and len(set(keys)) == len(keys):
        found.sort(key=lambda kv: natural(kv[0]))  # 장면 번호 순
    return [d for _, d in found]


def pick_even(items, n):
    if len(items) <= n:
        return items
    return [items[round(i * (len(items) - 1) / (n - 1))] for i in range(n)]


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    ff = shutil.which("ffmpeg")
    if not ff:
        sys.exit("!\tffmpeg를 찾을 수 없음")
    p = Path(sys.argv[1]); p = p if p.is_absolute() else ROOT / p
    if not p.is_file():
        sys.exit(f"!\t파일을 찾을 수 없음: {sys.argv[1]}")
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 20
    imgs = find_images(p.read_bytes())
    if not imgs:
        sys.exit(f"!\t{p.name} 안에 그림이 없음")
    total = len(imgs)
    imgs = pick_even(imgs, limit)
    out = OUT_ROOT / p.stem
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob("*.jpg"):
        old.unlink()
    tmp = out / "_tmp.img"
    done = 0
    for i, data in enumerate(imgs, 1):
        tmp.write_bytes(base64.b64decode(data))
        dst = out / f"{i:02d}.jpg"
        r = subprocess.run(
            [ff, "-y", "-loglevel", "error", "-i", str(tmp),
             "-vf", "scale=1080:1080:force_original_aspect_ratio=increase,crop=1080:1080",
             "-frames:v", "1", "-q:v", "2", str(dst)],
            capture_output=True)
        if r.returncode == 0 and dst.exists():
            done += 1
        else:
            print(f"!\t{i}번 그림 변환 실패: {r.stderr.decode('utf-8','ignore')[:120]}")
    tmp.unlink(missing_ok=True)
    print(f"OK\t{out}\t{done}장 (책 안 그림 {total}장 중)")


if __name__ == "__main__":
    main()
