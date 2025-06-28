
import os
import shutil

DATASETS_DIR = os.path.join('data', 'datasets')
RAW_DIR      = os.path.join('data', 'raw')

def merge_from_datasets(datasets_dir, raw_dir):
    for split in os.listdir(datasets_dir):
        split_dir = os.path.join(datasets_dir, split)
        if not os.path.isdir(split_dir):
            continue
        for cls in os.listdir(split_dir):
            src_cls_dir = os.path.join(split_dir, cls)
            dst_cls_dir = os.path.join(raw_dir, cls)
            if not os.path.isdir(src_cls_dir):
                continue
            os.makedirs(dst_cls_dir, exist_ok=True)
            for fname in os.listdir(src_cls_dir):
                src_file = os.path.join(src_cls_dir, fname)
                if not os.path.isfile(src_file):
                    continue
                dst_file = os.path.join(dst_cls_dir, fname)
                if os.path.exists(dst_file):
                    base, ext = os.path.splitext(fname)
                    i = 1
                    while True:
                        new_name = f"{base}_{i}{ext}"
                        new_path = os.path.join(dst_cls_dir, new_name)
                        if not os.path.exists(new_path):
                            dst_file = new_path
                            break
                        i += 1
                shutil.copy2(src_file, dst_file)
                print(f"Copiado {src_file} → {dst_file}")

if __name__ == '__main__':
    merge_from_datasets(DATASETS_DIR, RAW_DIR)
