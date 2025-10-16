# Firebase Cloud Functions for Excel Export
# This file contains HTTP Cloud Functions for generating Excel files from projection data

from firebase_functions import https_fn
from firebase_admin import initialize_app
import json

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

        # For Phase 1.2 - just return a test response
        response_data = {
            'message': 'Hello from Firebase Cloud Functions!',
            'received': {
                'hasProjection': 'projection' in request_json,
                'scenarioName': request_json.get('scenarioName', 'unknown'),
                'assetCount': len(request_json.get('assets', []))
            }
        }

        return https_fn.Response(
            json.dumps(response_data),
            status=200,
            headers={**headers, 'Content-Type': 'application/json'}
        )

    except Exception as e:
        return https_fn.Response(
            json.dumps({'error': f'Internal server error: {str(e)}'}),
            status=500,
            headers={**headers, 'Content-Type': 'application/json'}
        )
