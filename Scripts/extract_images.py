import fitz
import sys

if __name__ == "__main__":
    src_pdf: str = sys.argv[1]

    doc = fitz.open(src_pdf)
    nth: int = 1

    for page in doc.pages():
        for img_ref in page.get_images():
            img_info: dict = doc.extract_image(img_ref[0])
            with open(f"./pics/{nth:0>2}.{img_info['ext']}", "wb") as image:
                image.write(img_info['image'])
            nth += 1
