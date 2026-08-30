#!/usr/bin/env python3
import os
import sys
import zipfile
import argparse

def package(source_dir, output_zip):
    print(f"Creating standardized driver archive: {output_zip}")
    out_dir = os.path.dirname(os.path.abspath(output_zip))
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    with zipfile.ZipFile(output_zip, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for root, _, files in os.walk(source_dir):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, source_dir).replace('\\', '/')
                zi = zipfile.ZipInfo(rel_path)
                zi.external_attr = 0o644 << 16
                with open(full_path, 'rb') as f:
                    zf.writestr(zi, f.read())
    print(f"Successfully created {output_zip} ({os.path.getsize(output_zip)} bytes)")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Package STORM DRIVER for Adrenotools / Eden / Yuzu")
    parser.add_argument("--src", default="config", help="Source directory containing binaries and meta.json")
    parser.add_argument("--out", default="STORM_DRIVER.zip", help="Output zip archive")
    args = parser.parse_args()
    package(args.src, args.out)