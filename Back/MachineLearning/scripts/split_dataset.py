import os, shutil, random

SPLITS = {'train':0.7, 'val':0.15, 'test':0.15}
RAW_DIR    = os.path.join('data','raw')
OUTPUT_DIR = 'data'
SPLIT_DIRS = ['train','val','test']

def clean_splits():
    for sd in SPLIT_DIRS:
        path = os.path.join(OUTPUT_DIR, sd)
        if os.path.exists(path):
            shutil.rmtree(path)
        os.makedirs(path)

def make_dir(path):
    os.makedirs(path, exist_ok=True)

def split_class(files):
    random.shuffle(files)
    n = len(files)
    n_train = int(n * SPLITS['train'])
    n_val   = int(n * SPLITS['val'])
    return (files[:n_train],
            files[n_train:n_train+n_val],
            files[n_train+n_val:])

def copy_files(lst, cls, split_name):
    dst = os.path.join(OUTPUT_DIR, split_name, cls)
    make_dir(dst)
    for f in lst:
        shutil.copy2(
            os.path.join(RAW_DIR, cls, f),
            os.path.join(dst, f)
        )

def main():
    random.seed(42)
    clean_splits()
    clases = [d for d in os.listdir(RAW_DIR)
              if os.path.isdir(os.path.join(RAW_DIR,d))]
    for cls in clases:
        files = os.listdir(os.path.join(RAW_DIR, cls))
        train_f, val_f, test_f = split_class(files)
        copy_files(train_f, cls, 'train')
        copy_files(val_f,   cls, 'val')
        copy_files(test_f,  cls, 'test')
        print(f"{cls}: {len(train_f)}/{len(val_f)}/{len(test_f)}")

if __name__=='__main__':
    main()
