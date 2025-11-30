"""Reusable S3 sensor helper functions for Airflow DAGs.

These helpers centralize simple S3 existence checks so the main DAG files stay
focused on orchestration logic.

Functions
---------
csv_prefixes_ready(prefixes, aws_conn_id, bucket)
    Return True only if every prefix contains at least one .csv object.

s3_key_exists(key, aws_conn_id, bucket)
    Return True if an exact key exists.
"""
from __future__ import annotations

from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import logging
from typing import Sequence

DEFAULT_AWS_CONN_ID = "minio_conn"
DEFAULT_BUCKET = "vietnam-agriculture-data"


def s3_key_exists(*, key: str, aws_conn_id: str = DEFAULT_AWS_CONN_ID, bucket: str = DEFAULT_BUCKET, **_) -> bool:
    """Return True if the object key exists in the bucket."""
    s3 = S3Hook(aws_conn_id=aws_conn_id)
    return s3.get_key(key=key, bucket_name=bucket) is not None


def csv_prefixes_ready(
    *,
    prefixes: Sequence[str],
    aws_conn_id: str = DEFAULT_AWS_CONN_ID,
    bucket: str = DEFAULT_BUCKET,
    **_,
) -> bool:
    """Return True if each prefix contains at least one .csv object."""
    s3 = S3Hook(aws_conn_id=aws_conn_id)
    for p in prefixes:
        keys = s3.list_keys(bucket_name=bucket, prefix=p) or []
        has_csv = any(k.endswith(".csv") for k in keys)
        logging.info("Prefix %s has %d objects, csv_present=%s", p, len(keys), has_csv)
        if not has_csv:
            return False
    return True