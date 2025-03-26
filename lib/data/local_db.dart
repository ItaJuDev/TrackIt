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

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mode => text()(); // e.g., 'รายวัน', 'รายเดือน', 'รายปี'
  RealColumn get amount => real()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {mode},
      ];
}

final localDb = LocalDatabase();

@DriftDatabase(tables: [Transactions, Categories, Goals])
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

  Future<void> insertCategory(String name, bool isIncome) async {
    final existing = await (select(categories)
          ..where((c) => c.name.equals(name) & c.isIncome.equals(isIncome)))
        .getSingleOrNull();

    if (existing == null) {
      await into(categories).insert(CategoriesCompanion.insert(
        name: name,
        isIncome: Value(isIncome),
      ));
    }
  }

  Stream<List<Category>> watchCategories() => select(categories).watch();

  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((c) => c.id.equals(id))).go();
  }

  //Goals

  // Insert or update goal
  Future<void> upsertGoal(String mode, double amount) async {
    await await into(goals).insertOnConflictUpdate(GoalsCompanion(
      mode: Value(mode),
      amount: Value(amount),
    ));
  }

// Get goal by mode
  Future<Goal?> getGoalByMode(String mode) async {
    return (select(goals)..where((g) => g.mode.equals(mode)))
        .get()
        .then((rows) => rows.isNotEmpty ? rows.first : null);
  }

  Future<double> getSpentAmount(String mode) async {
    final transactions = await getAllTransactions();

    final now = DateTime.now();
    final filtered = transactions.where((t) {
      if (t.isIncome) return false; // Only expenses
      final date = DateTime.parse(t.date);

      switch (mode) {
        case 'รายวัน':
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        case 'รายเดือน':
          return date.year == now.year && date.month == now.month;
        case 'รายปี':
          return date.year == now.year;
        default:
          return false;
      }
    });

    final total = filtered.fold(0.0, (sum, t) => sum + t.amount);
    return total;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'trackit.sqlite'));
    return NativeDatabase(file);
  });
}
