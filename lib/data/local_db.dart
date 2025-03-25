import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'local_db.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()(); // Optional: for uniqueness
  RealColumn get amount => real()();
  TextColumn get date => text()(); // Could also use DateTimeColumn
  BoolColumn get isIncome => boolean()();
  TextColumn get category => text()();
  TextColumn get details => text().nullable()(); // optional details
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
}

final localDb = LocalDatabase();

@DriftDatabase(tables: [Transactions, Categories])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await m.addColumn(categories, categories.isIncome); // ✅ Add column
          }
        },
      );

  Future<void> deleteDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'trackit.sqlite');
    final file = File(dbPath);
    if (await file.exists()) {
      await file.delete();
      print('✅ Database deleted');
    }
  }

  // Transactions
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<int> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<bool> updateTransaction(TransactionsCompanion transaction) {
    return update(transactions).replace(transaction);
  }

  // Categories
  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Stream<List<Category>> watchCategories() => select(categories).watch();

  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'trackit.sqlite'));
    return NativeDatabase(file);
  });
}
