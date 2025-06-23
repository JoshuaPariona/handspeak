
import os
import cv2
import albumentations as A

RAW_DIR = 'data/raw'
N = 1

transforms = {
    'rotate': A.Affine(rotate=(-15, 15), p=1.0),
    'shift':  A.Affine(translate_percent={"x": (-0.1, 0.1), "y": (-0.1, 0.1)}, p=1.0),
    'zoom':   A.Affine(scale=(0.8, 1.2), p=1.0),
    'shear':  A.Affine(shear=(-10, 10), p=1.0),
    'bright': A.RandomBrightnessContrast(brightness_limit=0.2, contrast_limit=0.0, p=1.0)
}

def augment_by_technique():
    for cls in os.listdir(RAW_DIR):
        cls_dir = os.path.join(RAW_DIR, cls)
        if not os.path.isdir(cls_dir):
            continue

        originals = [
            f for f in os.listdir(cls_dir)
            if os.path.isfile(os.path.join(cls_dir, f))
               and '_tech_' not in f
        ]

        for fname in originals:
            img_path = os.path.join(cls_dir, fname)
            img = cv2.imread(img_path)
            if img is None:
                continue

            basename, ext = os.path.splitext(fname)

            for tech, tfm in transforms.items():
                for i in range(N):
                    augmented = tfm(image=img)['image']
                    out_name = f"{basename}_tech_{tech}{i}{ext}"
                    cv2.imwrite(os.path.join(cls_dir, out_name), augmented)


if __name__ == '__main__':
    augment_by_technique()
