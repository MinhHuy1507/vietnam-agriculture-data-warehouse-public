FROM apache/airflow:3.0.6

USER airflow
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

ENV PYTHONPATH="${PYTHONPATH}:/opt/airflow/python_scripts"
