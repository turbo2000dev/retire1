import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/assets/data/asset_repository.dart';
import 'package:retire1/features/assets/domain/asset.dart';

void main() {
  group('AssetRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late AssetRepository repository;
    const testProjectId = 'test-project-123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = AssetRepository(
        projectId: testProjectId,
        firestore: fakeFirestore,
      );
    });

    group('Create Asset', () {
      test('should create real estate asset', () async {
        final asset = Asset.realEstate(
          id: 'asset-1',
          type: RealEstateType.house,
          value: 500000,
          setAtStart: true,
          customReturnRate: 0.03,
        );

        await repository.createAsset(asset);

        final doc = await fakeFirestore
            .collection('projects')
            .doc(testProjectId)
            .collection('assets')
            .doc('asset-1')
            .get();

        expect(doc.exists, true);
        expect(doc.data()!['value'], 500000);
        expect(doc.data()!['runtimeType'], 'realEstate');
      });

      test('should create RRSP asset', () async {
        final asset = Asset.rrsp(
          id: 'asset-2',
          individualId: 'ind-1',
          value: 100000,
          customReturnRate: 0.06,
          annualContribution: 5000,
        );

        await repository.createAsset(asset);

        final retrieved = await repository.getAsset('asset-2');
        expect(retrieved, isNotNull);
        retrieved!.map(
          realEstate: (_) => fail('Expected RRSP'),
          rrsp: (a) {
            expect(a.id, 'asset-2');
            expect(a.individualId, 'ind-1');
            expect(a.value, 100000);
            expect(a.customReturnRate, 0.06);
            expect(a.annualContribution, 5000);
          },
          celi: (_) => fail('Expected RRSP'),
          cri: (_) => fail('Expected RRSP'),
          cash: (_) => fail('Expected RRSP'),
        );
      });

      test('should create CELI asset', () async {
        final asset = Asset.celi(
          id: 'asset-3',
          individualId: 'ind-1',
          value: 75000,
          customReturnRate: 0.05,
          annualContribution: 7000,
        );

        await repository.createAsset(asset);

        final retrieved = await repository.getAsset('asset-3');
        expect(retrieved, isNotNull);
        retrieved!.map(
          realEstate: (_) => fail('Expected CELI'),
          rrsp: (_) => fail('Expected CELI'),
          celi: (a) {
            expect(a.id, 'asset-3');
            expect(a.individualId, 'ind-1');
            expect(a.value, 75000);
            expect(a.customReturnRate, 0.05);
            expect(a.annualContribution, 7000);
          },
          cri: (_) => fail('Expected CELI'),
          cash: (_) => fail('Expected CELI'),
        );
      });

      test('should create CRI asset', () async {
        final asset = Asset.cri(
          id: 'asset-4',
          individualId: 'ind-1',
          value: 200000,
          contributionRoom: 10000,
          customReturnRate: 0.055,
          annualContribution: 3000,
        );

        await repository.createAsset(asset);

        final retrieved = await repository.getAsset('asset-4');
        expect(retrieved, isNotNull);
        retrieved!.map(
          realEstate: (_) => fail('Expected CRI'),
          rrsp: (_) => fail('Expected CRI'),
          celi: (_) => fail('Expected CRI'),
          cri: (a) {
            expect(a.id, 'asset-4');
            expect(a.individualId, 'ind-1');
            expect(a.value, 200000);
            expect(a.contributionRoom, 10000);
            expect(a.customReturnRate, 0.055);
            expect(a.annualContribution, 3000);
          },
          cash: (_) => fail('Expected CRI'),
        );
      });

      test('should create cash asset', () async {
        final asset = Asset.cash(
          id: 'asset-5',
          individualId: 'ind-1',
          value: 50000,
          customReturnRate: 0.02,
          annualContribution: 1000,
        );

        await repository.createAsset(asset);

        final retrieved = await repository.getAsset('asset-5');
        expect(retrieved, isNotNull);
        retrieved!.map(
          realEstate: (_) => fail('Expected Cash'),
          rrsp: (_) => fail('Expected Cash'),
          celi: (_) => fail('Expected Cash'),
          cri: (_) => fail('Expected Cash'),
          cash: (a) {
            expect(a.id, 'asset-5');
            expect(a.individualId, 'ind-1');
            expect(a.value, 50000);
            expect(a.customReturnRate, 0.02);
            expect(a.annualContribution, 1000);
          },
        );
      });
    });

    group('Read Asset', () {
      test('should get asset by ID', () async {
        final asset = Asset.rrsp(
          id: 'asset-1',
          individualId: 'ind-1',
          value: 100000,
        );

        await repository.createAsset(asset);
        final retrieved = await repository.getAsset('asset-1');

        expect(retrieved, isNotNull);
        expect(retrieved!.map(
          realEstate: (_) => null,
          rrsp: (a) => a.id,
          celi: (_) => null,
          cri: (_) => null,
          cash: (_) => null,
        ), 'asset-1');
      });

      test('should return null for non-existent asset', () async {
        final result = await repository.getAsset('non-existent-id');
        expect(result, isNull);
      });

      test('should get all assets for project', () async {
        await repository.createAsset(Asset.rrsp(
          id: 'asset-1',
          individualId: 'ind-1',
          value: 100000,
        ));
        await repository.createAsset(Asset.celi(
          id: 'asset-2',
          individualId: 'ind-1',
          value: 50000,
        ));
        await repository.createAsset(Asset.cash(
          id: 'asset-3',
          individualId: 'ind-1',
          value: 25000,
        ));

        final assets = await repository.getAssetsStream().first;

        expect(assets.length, 3);
        final ids = assets.map((a) => a.map(
          realEstate: (a) => a.id,
          rrsp: (a) => a.id,
          celi: (a) => a.id,
          cri: (a) => a.id,
          cash: (a) => a.id,
        )).toList();
        expect(ids, containsAll(['asset-1', 'asset-2', 'asset-3']));
      });

      test('should stream asset updates', () async {
        final stream = repository.getAssetsStream();

        // Create initial asset
        await repository.createAsset(Asset.rrsp(
          id: 'asset-1',
          individualId: 'ind-1',
          value: 100000,
        ));

        // Get first emission
        final firstEmission = await stream.first;
        expect(firstEmission.length, 1);
      });
    });

    group('Update Asset', () {
      test('should update real estate asset', () async {
        final original = Asset.realEstate(
          id: 'asset-1',
          type: RealEstateType.house,
          value: 500000,
        );

        await repository.createAsset(original);

        final updated = Asset.realEstate(
          id: 'asset-1',
          type: RealEstateType.condo,
          value: 600000,
          customReturnRate: 0.04,
        );

        await repository.updateAsset(updated);

        final retrieved = await repository.getAsset('asset-1');
        retrieved!.map(
          realEstate: (a) {
            expect(a.type, RealEstateType.condo);
            expect(a.value, 600000);
            expect(a.customReturnRate, 0.04);
          },
          rrsp: (_) => fail('Expected real estate'),
          celi: (_) => fail('Expected real estate'),
          cri: (_) => fail('Expected real estate'),
          cash: (_) => fail('Expected real estate'),
        );
      });

      test('should update RRSP asset values', () async {
        final original = Asset.rrsp(
          id: 'asset-2',
          individualId: 'ind-1',
          value: 100000,
        );

        await repository.createAsset(original);

        final updated = Asset.rrsp(
          id: 'asset-2',
          individualId: 'ind-1',
          value: 120000,
          annualContribution: 6000,
        );

        await repository.updateAsset(updated);

        final retrieved = await repository.getAsset('asset-2');
        retrieved!.map(
          realEstate: (_) => fail('Expected RRSP'),
          rrsp: (a) {
            expect(a.value, 120000);
            expect(a.annualContribution, 6000);
          },
          celi: (_) => fail('Expected RRSP'),
          cri: (_) => fail('Expected RRSP'),
          cash: (_) => fail('Expected RRSP'),
        );
      });
    });

    group('Delete Asset', () {
      test('should delete asset from Firestore', () async {
        final asset = Asset.rrsp(
          id: 'asset-1',
          individualId: 'ind-1',
          value: 100000,
        );

        await repository.createAsset(asset);
        await repository.deleteAsset('asset-1');

        final retrieved = await repository.getAsset('asset-1');
        expect(retrieved, isNull);
      });

      test('should remove asset from stream', () async {
        await repository.createAsset(Asset.rrsp(
          id: 'asset-1',
          individualId: 'ind-1',
          value: 100000,
        ));
        await repository.createAsset(Asset.celi(
          id: 'asset-2',
          individualId: 'ind-1',
          value: 50000,
        ));

        await repository.deleteAsset('asset-1');

        final assets = await repository.getAssetsStream().first;
        expect(assets.length, 1);
        final remainingId = assets[0].map(
          realEstate: (a) => a.id,
          rrsp: (a) => a.id,
          celi: (a) => a.id,
          cri: (a) => a.id,
          cash: (a) => a.id,
        );
        expect(remainingId, 'asset-2');
      });
    });

    group('Union Type Serialization', () {
      test('should preserve real estate type through serialization', () async {
        final asset = Asset.realEstate(
          id: 'asset-1',
          type: RealEstateType.cottage,
          value: 300000,
          setAtStart: true,
        );

        await repository.createAsset(asset);
        final retrieved = await repository.getAsset('asset-1');

        expect(retrieved, isNotNull);
        retrieved!.map(
          realEstate: (a) {
            expect(a.type, RealEstateType.cottage);
            expect(a.setAtStart, true);
          },
          rrsp: (_) => fail('Expected real estate'),
          celi: (_) => fail('Expected real estate'),
          cri: (_) => fail('Expected real estate'),
          cash: (_) => fail('Expected real estate'),
        );
      });

      test('should handle all real estate types', () async {
        final types = [
          RealEstateType.house,
          RealEstateType.condo,
          RealEstateType.cottage,
          RealEstateType.land,
          RealEstateType.commercial,
          RealEstateType.other,
        ];

        for (int i = 0; i < types.length; i++) {
          final asset = Asset.realEstate(
            id: 'asset-$i',
            type: types[i],
            value: 100000.0 * (i + 1),
          );

          await repository.createAsset(asset);
          final retrieved = await repository.getAsset('asset-$i');

          expect(retrieved, isNotNull);
          retrieved!.map(
            realEstate: (a) => expect(a.type, types[i]),
            rrsp: (_) => fail('Expected real estate'),
            celi: (_) => fail('Expected real estate'),
            cri: (_) => fail('Expected real estate'),
            cash: (_) => fail('Expected real estate'),
          );
        }
      });

      test('should handle nullable fields correctly', () async {
        final assetWithNulls = Asset.rrsp(
          id: 'asset-1',
          individualId: 'ind-1',
          value: 100000,
          customReturnRate: null,
          annualContribution: null,
        );

        await repository.createAsset(assetWithNulls);
        final retrieved = await repository.getAsset('asset-1');

        retrieved!.map(
          realEstate: (_) => fail('Expected RRSP'),
          rrsp: (a) {
            expect(a.customReturnRate, isNull);
            expect(a.annualContribution, isNull);
          },
          celi: (_) => fail('Expected RRSP'),
          cri: (_) => fail('Expected RRSP'),
          cash: (_) => fail('Expected RRSP'),
        );

        final assetWithValues = Asset.rrsp(
          id: 'asset-2',
          individualId: 'ind-1',
          value: 100000,
          customReturnRate: 0.06,
          annualContribution: 5000,
        );

        await repository.createAsset(assetWithValues);
        final retrieved2 = await repository.getAsset('asset-2');

        retrieved2!.map(
          realEstate: (_) => fail('Expected RRSP'),
          rrsp: (a) {
            expect(a.customReturnRate, 0.06);
            expect(a.annualContribution, 5000);
          },
          celi: (_) => fail('Expected RRSP'),
          cri: (_) => fail('Expected RRSP'),
          cash: (_) => fail('Expected RRSP'),
        );
      });
    });

    group('Data Integrity', () {
      test('should maintain all fields through round-trip for each type', () async {
        // Test each asset type
        final assets = [
          Asset.realEstate(
            id: 'asset-re',
            type: RealEstateType.house,
            value: 500000,
            setAtStart: true,
            customReturnRate: 0.03,
          ),
          Asset.rrsp(
            id: 'asset-rrsp',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: 0.06,
            annualContribution: 5000,
          ),
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 75000,
            customReturnRate: 0.05,
            annualContribution: 7000,
          ),
          Asset.cri(
            id: 'asset-cri',
            individualId: 'ind-1',
            value: 200000,
            contributionRoom: 10000,
            customReturnRate: 0.055,
            annualContribution: 3000,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: 0.02,
            annualContribution: 1000,
          ),
        ];

        for (final asset in assets) {
          await repository.createAsset(asset);
          final retrieved = await repository.getAsset(
            asset.map(
              realEstate: (a) => a.id,
              rrsp: (a) => a.id,
              celi: (a) => a.id,
              cri: (a) => a.id,
              cash: (a) => a.id,
            ),
          );

          expect(retrieved, isNotNull);
          expect(retrieved!.toJson(), equals(asset.toJson()));
        }
      });
    });

    group('Error Handling', () {
      test('should handle empty project collection', () async {
        final assets = await repository.getAssetsStream().first;
        expect(assets, isEmpty);
      });
    });
  });
}
