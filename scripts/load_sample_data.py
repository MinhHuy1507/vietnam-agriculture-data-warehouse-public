"""
File: scripts/load_sample_data.py
Descriptions: Loads sample data from the sample directory into the raw data directory.
Notes: Use this script to populate the raw data folder with sample files for testing or demo purposes after cloning the repository.
"""
import os
import shutil

# Define paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW_DIR = os.path.join(BASE_DIR, 'data', 'raw')
SAMPLE_DIR = os.path.join(BASE_DIR, 'data', 'sample')

def load_sample():
    print(f"Loading sample data from {SAMPLE_DIR} to {RAW_DIR}...")
    
    if not os.path.exists(SAMPLE_DIR):
        print("❌ Sample directory not found!")
        return

    # Create raw directory if not exists
    os.makedirs(RAW_DIR, exist_ok=True)
    
    files = [f for f in os.listdir(SAMPLE_DIR) if f.endswith('.csv')]
    
    if not files:
        print("No sample files found.")
        return

    for file in files:
        source_path = os.path.join(SAMPLE_DIR, file)
        dest_path = os.path.join(RAW_DIR, file)
        
        try:
            shutil.copy2(source_path, dest_path)
            print(f"✅ Loaded: {file}")
        except Exception as e:
            print(f"❌ Error loading {file}: {str(e)}")

if __name__ == "__main__":
    load_sample()
