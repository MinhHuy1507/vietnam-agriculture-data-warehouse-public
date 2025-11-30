"""
File: scripts/generate_sample_data.py
Descriptions: Generates sample datasets by extracting the first 100 rows from CSV files in the raw data directory.
Notes: Requires pandas. Run this script before committing to create lightweight sample data for the repository.
"""
import pandas as pd
import os
import shutil

# Define paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(BASE_DIR, 'data', 'raw')
SAMPLE_DIR = os.path.join(BASE_DIR, 'data', 'sample')

# Create sample directory if not exists
os.makedirs(SAMPLE_DIR, exist_ok=True)

def generate_sample():
    print(f"Generating samples from {RAW_DIR} to {SAMPLE_DIR}...")
    
    # List all CSV files in raw directory
    files = [f for f in os.listdir(RAW_DIR) if f.endswith('.csv')]
    
    if not files:
        print("No CSV files found in data/raw/")
        return

    for file in files:
        source_path = os.path.join(RAW_DIR, file)
        dest_path = os.path.join(SAMPLE_DIR, file)
        
        try:
            # Read first 100 rows
            df = pd.read_csv(source_path, nrows=100)
            # Save to sample directory
            df.to_csv(dest_path, index=False)
            print(f"Created sample for: {file} (100 rows)")
        except Exception as e:
            print(f"Error processing {file}: {str(e)}")

if __name__ == "__main__":
    generate_sample()
