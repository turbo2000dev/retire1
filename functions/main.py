# Firebase Cloud Functions for Excel Export
# This file contains HTTP Cloud Functions for generating Excel files from projection data

from firebase_functions import https_fn
from firebase_admin import initialize_app
import json
from datetime import datetime
import time

from models import Projection, Asset
from excel_generator import ExcelGenerator

# Initialize Firebase Admin SDK
initialize_app()


@https_fn.on_request()
def generate_projection_excel(req: https_fn.Request) -> https_fn.Response:
    """
    HTTP Cloud Function to generate Excel file from projection data.

    Expected request body (JSON):
    {
        "projection": {...},
        "scenarioName": "string",
        "assets": [...]
    }

    Returns: Excel file as binary response
    """

    # CORS headers for Flutter web client
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
    }

    # Handle preflight CORS request
    if req.method == 'OPTIONS':
        return https_fn.Response('', status=204, headers=headers)

    # Only accept POST requests
    if req.method != 'POST':
        return https_fn.Response(
            json.dumps({'error': 'Method not allowed. Use POST.'}),
            status=405,
            headers={**headers, 'Content-Type': 'application/json'}
        )

    try:
        # Parse request body
        request_json = req.get_json(silent=True)

        if not request_json:
            return https_fn.Response(
                json.dumps({'error': 'Invalid JSON in request body'}),
                status=400,
                headers={**headers, 'Content-Type': 'application/json'}
            )

        # Validate required fields
        if 'projection' not in request_json:
            return https_fn.Response(
                json.dumps({'error': 'Missing required field: projection'}),
                status=400,
                headers={**headers, 'Content-Type': 'application/json'}
            )

        # Start performance monitoring
        start_time = time.time()

        # Parse data models
        parse_start = time.time()
        projection = Projection.from_dict(request_json['projection'])
        scenario_name = request_json.get('scenarioName', 'Projection')
        assets = [Asset.from_dict(asset_data) for asset_data in request_json.get('assets', [])]
        parse_time = time.time() - parse_start

        # Generate Excel file
        gen_start = time.time()
        generator = ExcelGenerator(projection, scenario_name, assets)
        excel_bytes = generator.generate()
        gen_time = time.time() - gen_start

        # Total time
        total_time = time.time() - start_time

        # Log performance metrics
        print(f'Excel generation performance:')
        print(f'  - Projection years: {len(projection.years)}')
        print(f'  - Assets count: {len(assets)}')
        print(f'  - Parse time: {parse_time*1000:.1f}ms')
        print(f'  - Generation time: {gen_time*1000:.1f}ms')
        print(f'  - Total time: {total_time*1000:.1f}ms')
        print(f'  - File size: {len(excel_bytes):,} bytes')

        # Generate filename
        today = datetime.now().strftime('%Y-%m-%d')
        filename = f'projection_{scenario_name.replace(" ", "-")}_{today}.xlsx'

        # Return Excel file
        return https_fn.Response(
            excel_bytes,
            status=200,
            headers={
                **headers,
                'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                'Content-Disposition': f'attachment; filename="{filename}"',
            }
        )

    except KeyError as e:
        return https_fn.Response(
            json.dumps({'error': f'Missing required field: {str(e)}'}),
            status=400,
            headers={**headers, 'Content-Type': 'application/json'}
        )
    except Exception as e:
        # Log the full error for debugging
        print(f'Error generating Excel: {str(e)}')
        import traceback
        traceback.print_exc()

        return https_fn.Response(
            json.dumps({'error': f'Internal server error: {str(e)}'}),
            status=500,
            headers={**headers, 'Content-Type': 'application/json'}
        )
