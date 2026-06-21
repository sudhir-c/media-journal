// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EntriesTable extends Entries with TableInfo<$EntriesTable, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creatorsMeta = const VerificationMeta(
    'creators',
  );
  @override
  late final GeneratedColumn<String> creators = GeneratedColumn<String>(
    'creators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalRawMeta = const VerificationMeta(
    'externalRaw',
  );
  @override
  late final GeneratedColumn<String> externalRaw = GeneratedColumn<String>(
    'external_raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('done'),
  );
  static const VerificationMeta _consumedDateMeta = const VerificationMeta(
    'consumedDate',
  );
  @override
  late final GeneratedColumn<String> consumedDate = GeneratedColumn<String>(
    'consumed_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entertainmentMeta = const VerificationMeta(
    'entertainment',
  );
  @override
  late final GeneratedColumn<int> entertainment = GeneratedColumn<int>(
    'entertainment',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thematicDepthMeta = const VerificationMeta(
    'thematicDepth',
  );
  @override
  late final GeneratedColumn<int> thematicDepth = GeneratedColumn<int>(
    'thematic_depth',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atmosphereMeta = const VerificationMeta(
    'atmosphere',
  );
  @override
  late final GeneratedColumn<int> atmosphere = GeneratedColumn<int>(
    'atmosphere',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performancesMeta = const VerificationMeta(
    'performances',
  );
  @override
  late final GeneratedColumn<int> performances = GeneratedColumn<int>(
    'performances',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _narrativeArcMeta = const VerificationMeta(
    'narrativeArc',
  );
  @override
  late final GeneratedColumn<int> narrativeArc = GeneratedColumn<int>(
    'narrative_arc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _charactersMeta = const VerificationMeta(
    'characters',
  );
  @override
  late final GeneratedColumn<int> characters = GeneratedColumn<int>(
    'characters',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insightMeta = const VerificationMeta(
    'insight',
  );
  @override
  late final GeneratedColumn<int> insight = GeneratedColumn<int>(
    'insight',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rigorMeta = const VerificationMeta('rigor');
  @override
  late final GeneratedColumn<int> rigor = GeneratedColumn<int>(
    'rigor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _engagementMeta = const VerificationMeta(
    'engagement',
  );
  @override
  late final GeneratedColumn<int> engagement = GeneratedColumn<int>(
    'engagement',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proMeta = const VerificationMeta('pro');
  @override
  late final GeneratedColumn<String> pro = GeneratedColumn<String>(
    'pro',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _conMeta = const VerificationMeta('con');
  @override
  late final GeneratedColumn<String> con = GeneratedColumn<String>(
    'con',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    title,
    creators,
    year,
    coverUrl,
    source,
    externalId,
    externalRaw,
    status,
    consumedDate,
    entertainment,
    thematicDepth,
    atmosphere,
    performances,
    narrativeArc,
    characters,
    insight,
    rigor,
    engagement,
    pro,
    con,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('creators')) {
      context.handle(
        _creatorsMeta,
        creators.isAcceptableOrUnknown(data['creators']!, _creatorsMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('external_raw')) {
      context.handle(
        _externalRawMeta,
        externalRaw.isAcceptableOrUnknown(
          data['external_raw']!,
          _externalRawMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('consumed_date')) {
      context.handle(
        _consumedDateMeta,
        consumedDate.isAcceptableOrUnknown(
          data['consumed_date']!,
          _consumedDateMeta,
        ),
      );
    }
    if (data.containsKey('entertainment')) {
      context.handle(
        _entertainmentMeta,
        entertainment.isAcceptableOrUnknown(
          data['entertainment']!,
          _entertainmentMeta,
        ),
      );
    }
    if (data.containsKey('thematic_depth')) {
      context.handle(
        _thematicDepthMeta,
        thematicDepth.isAcceptableOrUnknown(
          data['thematic_depth']!,
          _thematicDepthMeta,
        ),
      );
    }
    if (data.containsKey('atmosphere')) {
      context.handle(
        _atmosphereMeta,
        atmosphere.isAcceptableOrUnknown(data['atmosphere']!, _atmosphereMeta),
      );
    }
    if (data.containsKey('performances')) {
      context.handle(
        _performancesMeta,
        performances.isAcceptableOrUnknown(
          data['performances']!,
          _performancesMeta,
        ),
      );
    }
    if (data.containsKey('narrative_arc')) {
      context.handle(
        _narrativeArcMeta,
        narrativeArc.isAcceptableOrUnknown(
          data['narrative_arc']!,
          _narrativeArcMeta,
        ),
      );
    }
    if (data.containsKey('characters')) {
      context.handle(
        _charactersMeta,
        characters.isAcceptableOrUnknown(data['characters']!, _charactersMeta),
      );
    }
    if (data.containsKey('insight')) {
      context.handle(
        _insightMeta,
        insight.isAcceptableOrUnknown(data['insight']!, _insightMeta),
      );
    }
    if (data.containsKey('rigor')) {
      context.handle(
        _rigorMeta,
        rigor.isAcceptableOrUnknown(data['rigor']!, _rigorMeta),
      );
    }
    if (data.containsKey('engagement')) {
      context.handle(
        _engagementMeta,
        engagement.isAcceptableOrUnknown(data['engagement']!, _engagementMeta),
      );
    }
    if (data.containsKey('pro')) {
      context.handle(
        _proMeta,
        pro.isAcceptableOrUnknown(data['pro']!, _proMeta),
      );
    }
    if (data.containsKey('con')) {
      context.handle(
        _conMeta,
        con.isAcceptableOrUnknown(data['con']!, _conMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      creators: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creators'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      externalRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_raw'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      consumedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consumed_date'],
      ),
      entertainment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entertainment'],
      ),
      thematicDepth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}thematic_depth'],
      ),
      atmosphere: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}atmosphere'],
      ),
      performances: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}performances'],
      ),
      narrativeArc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}narrative_arc'],
      ),
      characters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}characters'],
      ),
      insight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}insight'],
      ),
      rigor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rigor'],
      ),
      engagement: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engagement'],
      ),
      pro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pro'],
      )!,
      con: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}con'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }
}

class Entry extends DataClass implements Insertable<Entry> {
  final String id;
  final String category;
  final String title;
  final String creators;
  final int? year;
  final String? coverUrl;
  final String source;
  final String? externalId;
  final String? externalRaw;
  final String status;
  final String? consumedDate;
  final int? entertainment;
  final int? thematicDepth;
  final int? atmosphere;
  final int? performances;
  final int? narrativeArc;
  final int? characters;
  final int? insight;
  final int? rigor;
  final int? engagement;
  final String pro;
  final String con;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Entry({
    required this.id,
    required this.category,
    required this.title,
    required this.creators,
    this.year,
    this.coverUrl,
    required this.source,
    this.externalId,
    this.externalRaw,
    required this.status,
    this.consumedDate,
    this.entertainment,
    this.thematicDepth,
    this.atmosphere,
    this.performances,
    this.narrativeArc,
    this.characters,
    this.insight,
    this.rigor,
    this.engagement,
    required this.pro,
    required this.con,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['creators'] = Variable<String>(creators);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || externalRaw != null) {
      map['external_raw'] = Variable<String>(externalRaw);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || consumedDate != null) {
      map['consumed_date'] = Variable<String>(consumedDate);
    }
    if (!nullToAbsent || entertainment != null) {
      map['entertainment'] = Variable<int>(entertainment);
    }
    if (!nullToAbsent || thematicDepth != null) {
      map['thematic_depth'] = Variable<int>(thematicDepth);
    }
    if (!nullToAbsent || atmosphere != null) {
      map['atmosphere'] = Variable<int>(atmosphere);
    }
    if (!nullToAbsent || performances != null) {
      map['performances'] = Variable<int>(performances);
    }
    if (!nullToAbsent || narrativeArc != null) {
      map['narrative_arc'] = Variable<int>(narrativeArc);
    }
    if (!nullToAbsent || characters != null) {
      map['characters'] = Variable<int>(characters);
    }
    if (!nullToAbsent || insight != null) {
      map['insight'] = Variable<int>(insight);
    }
    if (!nullToAbsent || rigor != null) {
      map['rigor'] = Variable<int>(rigor);
    }
    if (!nullToAbsent || engagement != null) {
      map['engagement'] = Variable<int>(engagement);
    }
    map['pro'] = Variable<String>(pro);
    map['con'] = Variable<String>(con);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      category: Value(category),
      title: Value(title),
      creators: Value(creators),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      source: Value(source),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      externalRaw: externalRaw == null && nullToAbsent
          ? const Value.absent()
          : Value(externalRaw),
      status: Value(status),
      consumedDate: consumedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(consumedDate),
      entertainment: entertainment == null && nullToAbsent
          ? const Value.absent()
          : Value(entertainment),
      thematicDepth: thematicDepth == null && nullToAbsent
          ? const Value.absent()
          : Value(thematicDepth),
      atmosphere: atmosphere == null && nullToAbsent
          ? const Value.absent()
          : Value(atmosphere),
      performances: performances == null && nullToAbsent
          ? const Value.absent()
          : Value(performances),
      narrativeArc: narrativeArc == null && nullToAbsent
          ? const Value.absent()
          : Value(narrativeArc),
      characters: characters == null && nullToAbsent
          ? const Value.absent()
          : Value(characters),
      insight: insight == null && nullToAbsent
          ? const Value.absent()
          : Value(insight),
      rigor: rigor == null && nullToAbsent
          ? const Value.absent()
          : Value(rigor),
      engagement: engagement == null && nullToAbsent
          ? const Value.absent()
          : Value(engagement),
      pro: Value(pro),
      con: Value(con),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Entry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      creators: serializer.fromJson<String>(json['creators']),
      year: serializer.fromJson<int?>(json['year']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      externalRaw: serializer.fromJson<String?>(json['externalRaw']),
      status: serializer.fromJson<String>(json['status']),
      consumedDate: serializer.fromJson<String?>(json['consumedDate']),
      entertainment: serializer.fromJson<int?>(json['entertainment']),
      thematicDepth: serializer.fromJson<int?>(json['thematicDepth']),
      atmosphere: serializer.fromJson<int?>(json['atmosphere']),
      performances: serializer.fromJson<int?>(json['performances']),
      narrativeArc: serializer.fromJson<int?>(json['narrativeArc']),
      characters: serializer.fromJson<int?>(json['characters']),
      insight: serializer.fromJson<int?>(json['insight']),
      rigor: serializer.fromJson<int?>(json['rigor']),
      engagement: serializer.fromJson<int?>(json['engagement']),
      pro: serializer.fromJson<String>(json['pro']),
      con: serializer.fromJson<String>(json['con']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'creators': serializer.toJson<String>(creators),
      'year': serializer.toJson<int?>(year),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String?>(externalId),
      'externalRaw': serializer.toJson<String?>(externalRaw),
      'status': serializer.toJson<String>(status),
      'consumedDate': serializer.toJson<String?>(consumedDate),
      'entertainment': serializer.toJson<int?>(entertainment),
      'thematicDepth': serializer.toJson<int?>(thematicDepth),
      'atmosphere': serializer.toJson<int?>(atmosphere),
      'performances': serializer.toJson<int?>(performances),
      'narrativeArc': serializer.toJson<int?>(narrativeArc),
      'characters': serializer.toJson<int?>(characters),
      'insight': serializer.toJson<int?>(insight),
      'rigor': serializer.toJson<int?>(rigor),
      'engagement': serializer.toJson<int?>(engagement),
      'pro': serializer.toJson<String>(pro),
      'con': serializer.toJson<String>(con),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Entry copyWith({
    String? id,
    String? category,
    String? title,
    String? creators,
    Value<int?> year = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    String? source,
    Value<String?> externalId = const Value.absent(),
    Value<String?> externalRaw = const Value.absent(),
    String? status,
    Value<String?> consumedDate = const Value.absent(),
    Value<int?> entertainment = const Value.absent(),
    Value<int?> thematicDepth = const Value.absent(),
    Value<int?> atmosphere = const Value.absent(),
    Value<int?> performances = const Value.absent(),
    Value<int?> narrativeArc = const Value.absent(),
    Value<int?> characters = const Value.absent(),
    Value<int?> insight = const Value.absent(),
    Value<int?> rigor = const Value.absent(),
    Value<int?> engagement = const Value.absent(),
    String? pro,
    String? con,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Entry(
    id: id ?? this.id,
    category: category ?? this.category,
    title: title ?? this.title,
    creators: creators ?? this.creators,
    year: year.present ? year.value : this.year,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    source: source ?? this.source,
    externalId: externalId.present ? externalId.value : this.externalId,
    externalRaw: externalRaw.present ? externalRaw.value : this.externalRaw,
    status: status ?? this.status,
    consumedDate: consumedDate.present ? consumedDate.value : this.consumedDate,
    entertainment: entertainment.present
        ? entertainment.value
        : this.entertainment,
    thematicDepth: thematicDepth.present
        ? thematicDepth.value
        : this.thematicDepth,
    atmosphere: atmosphere.present ? atmosphere.value : this.atmosphere,
    performances: performances.present ? performances.value : this.performances,
    narrativeArc: narrativeArc.present ? narrativeArc.value : this.narrativeArc,
    characters: characters.present ? characters.value : this.characters,
    insight: insight.present ? insight.value : this.insight,
    rigor: rigor.present ? rigor.value : this.rigor,
    engagement: engagement.present ? engagement.value : this.engagement,
    pro: pro ?? this.pro,
    con: con ?? this.con,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      creators: data.creators.present ? data.creators.value : this.creators,
      year: data.year.present ? data.year.value : this.year,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      externalRaw: data.externalRaw.present
          ? data.externalRaw.value
          : this.externalRaw,
      status: data.status.present ? data.status.value : this.status,
      consumedDate: data.consumedDate.present
          ? data.consumedDate.value
          : this.consumedDate,
      entertainment: data.entertainment.present
          ? data.entertainment.value
          : this.entertainment,
      thematicDepth: data.thematicDepth.present
          ? data.thematicDepth.value
          : this.thematicDepth,
      atmosphere: data.atmosphere.present
          ? data.atmosphere.value
          : this.atmosphere,
      performances: data.performances.present
          ? data.performances.value
          : this.performances,
      narrativeArc: data.narrativeArc.present
          ? data.narrativeArc.value
          : this.narrativeArc,
      characters: data.characters.present
          ? data.characters.value
          : this.characters,
      insight: data.insight.present ? data.insight.value : this.insight,
      rigor: data.rigor.present ? data.rigor.value : this.rigor,
      engagement: data.engagement.present
          ? data.engagement.value
          : this.engagement,
      pro: data.pro.present ? data.pro.value : this.pro,
      con: data.con.present ? data.con.value : this.con,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entry(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('creators: $creators, ')
          ..write('year: $year, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('externalRaw: $externalRaw, ')
          ..write('status: $status, ')
          ..write('consumedDate: $consumedDate, ')
          ..write('entertainment: $entertainment, ')
          ..write('thematicDepth: $thematicDepth, ')
          ..write('atmosphere: $atmosphere, ')
          ..write('performances: $performances, ')
          ..write('narrativeArc: $narrativeArc, ')
          ..write('characters: $characters, ')
          ..write('insight: $insight, ')
          ..write('rigor: $rigor, ')
          ..write('engagement: $engagement, ')
          ..write('pro: $pro, ')
          ..write('con: $con, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    category,
    title,
    creators,
    year,
    coverUrl,
    source,
    externalId,
    externalRaw,
    status,
    consumedDate,
    entertainment,
    thematicDepth,
    atmosphere,
    performances,
    narrativeArc,
    characters,
    insight,
    rigor,
    engagement,
    pro,
    con,
    notes,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entry &&
          other.id == this.id &&
          other.category == this.category &&
          other.title == this.title &&
          other.creators == this.creators &&
          other.year == this.year &&
          other.coverUrl == this.coverUrl &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.externalRaw == this.externalRaw &&
          other.status == this.status &&
          other.consumedDate == this.consumedDate &&
          other.entertainment == this.entertainment &&
          other.thematicDepth == this.thematicDepth &&
          other.atmosphere == this.atmosphere &&
          other.performances == this.performances &&
          other.narrativeArc == this.narrativeArc &&
          other.characters == this.characters &&
          other.insight == this.insight &&
          other.rigor == this.rigor &&
          other.engagement == this.engagement &&
          other.pro == this.pro &&
          other.con == this.con &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EntriesCompanion extends UpdateCompanion<Entry> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> title;
  final Value<String> creators;
  final Value<int?> year;
  final Value<String?> coverUrl;
  final Value<String> source;
  final Value<String?> externalId;
  final Value<String?> externalRaw;
  final Value<String> status;
  final Value<String?> consumedDate;
  final Value<int?> entertainment;
  final Value<int?> thematicDepth;
  final Value<int?> atmosphere;
  final Value<int?> performances;
  final Value<int?> narrativeArc;
  final Value<int?> characters;
  final Value<int?> insight;
  final Value<int?> rigor;
  final Value<int?> engagement;
  final Value<String> pro;
  final Value<String> con;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.creators = const Value.absent(),
    this.year = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.externalRaw = const Value.absent(),
    this.status = const Value.absent(),
    this.consumedDate = const Value.absent(),
    this.entertainment = const Value.absent(),
    this.thematicDepth = const Value.absent(),
    this.atmosphere = const Value.absent(),
    this.performances = const Value.absent(),
    this.narrativeArc = const Value.absent(),
    this.characters = const Value.absent(),
    this.insight = const Value.absent(),
    this.rigor = const Value.absent(),
    this.engagement = const Value.absent(),
    this.pro = const Value.absent(),
    this.con = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntriesCompanion.insert({
    required String id,
    required String category,
    required String title,
    this.creators = const Value.absent(),
    this.year = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.externalRaw = const Value.absent(),
    this.status = const Value.absent(),
    this.consumedDate = const Value.absent(),
    this.entertainment = const Value.absent(),
    this.thematicDepth = const Value.absent(),
    this.atmosphere = const Value.absent(),
    this.performances = const Value.absent(),
    this.narrativeArc = const Value.absent(),
    this.characters = const Value.absent(),
    this.insight = const Value.absent(),
    this.rigor = const Value.absent(),
    this.engagement = const Value.absent(),
    this.pro = const Value.absent(),
    this.con = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Entry> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? creators,
    Expression<int>? year,
    Expression<String>? coverUrl,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<String>? externalRaw,
    Expression<String>? status,
    Expression<String>? consumedDate,
    Expression<int>? entertainment,
    Expression<int>? thematicDepth,
    Expression<int>? atmosphere,
    Expression<int>? performances,
    Expression<int>? narrativeArc,
    Expression<int>? characters,
    Expression<int>? insight,
    Expression<int>? rigor,
    Expression<int>? engagement,
    Expression<String>? pro,
    Expression<String>? con,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (creators != null) 'creators': creators,
      if (year != null) 'year': year,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (externalRaw != null) 'external_raw': externalRaw,
      if (status != null) 'status': status,
      if (consumedDate != null) 'consumed_date': consumedDate,
      if (entertainment != null) 'entertainment': entertainment,
      if (thematicDepth != null) 'thematic_depth': thematicDepth,
      if (atmosphere != null) 'atmosphere': atmosphere,
      if (performances != null) 'performances': performances,
      if (narrativeArc != null) 'narrative_arc': narrativeArc,
      if (characters != null) 'characters': characters,
      if (insight != null) 'insight': insight,
      if (rigor != null) 'rigor': rigor,
      if (engagement != null) 'engagement': engagement,
      if (pro != null) 'pro': pro,
      if (con != null) 'con': con,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<String>? title,
    Value<String>? creators,
    Value<int?>? year,
    Value<String?>? coverUrl,
    Value<String>? source,
    Value<String?>? externalId,
    Value<String?>? externalRaw,
    Value<String>? status,
    Value<String?>? consumedDate,
    Value<int?>? entertainment,
    Value<int?>? thematicDepth,
    Value<int?>? atmosphere,
    Value<int?>? performances,
    Value<int?>? narrativeArc,
    Value<int?>? characters,
    Value<int?>? insight,
    Value<int?>? rigor,
    Value<int?>? engagement,
    Value<String>? pro,
    Value<String>? con,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      creators: creators ?? this.creators,
      year: year ?? this.year,
      coverUrl: coverUrl ?? this.coverUrl,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      externalRaw: externalRaw ?? this.externalRaw,
      status: status ?? this.status,
      consumedDate: consumedDate ?? this.consumedDate,
      entertainment: entertainment ?? this.entertainment,
      thematicDepth: thematicDepth ?? this.thematicDepth,
      atmosphere: atmosphere ?? this.atmosphere,
      performances: performances ?? this.performances,
      narrativeArc: narrativeArc ?? this.narrativeArc,
      characters: characters ?? this.characters,
      insight: insight ?? this.insight,
      rigor: rigor ?? this.rigor,
      engagement: engagement ?? this.engagement,
      pro: pro ?? this.pro,
      con: con ?? this.con,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (creators.present) {
      map['creators'] = Variable<String>(creators.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (externalRaw.present) {
      map['external_raw'] = Variable<String>(externalRaw.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (consumedDate.present) {
      map['consumed_date'] = Variable<String>(consumedDate.value);
    }
    if (entertainment.present) {
      map['entertainment'] = Variable<int>(entertainment.value);
    }
    if (thematicDepth.present) {
      map['thematic_depth'] = Variable<int>(thematicDepth.value);
    }
    if (atmosphere.present) {
      map['atmosphere'] = Variable<int>(atmosphere.value);
    }
    if (performances.present) {
      map['performances'] = Variable<int>(performances.value);
    }
    if (narrativeArc.present) {
      map['narrative_arc'] = Variable<int>(narrativeArc.value);
    }
    if (characters.present) {
      map['characters'] = Variable<int>(characters.value);
    }
    if (insight.present) {
      map['insight'] = Variable<int>(insight.value);
    }
    if (rigor.present) {
      map['rigor'] = Variable<int>(rigor.value);
    }
    if (engagement.present) {
      map['engagement'] = Variable<int>(engagement.value);
    }
    if (pro.present) {
      map['pro'] = Variable<String>(pro.value);
    }
    if (con.present) {
      map['con'] = Variable<String>(con.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('creators: $creators, ')
          ..write('year: $year, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('externalRaw: $externalRaw, ')
          ..write('status: $status, ')
          ..write('consumedDate: $consumedDate, ')
          ..write('entertainment: $entertainment, ')
          ..write('thematicDepth: $thematicDepth, ')
          ..write('atmosphere: $atmosphere, ')
          ..write('performances: $performances, ')
          ..write('narrativeArc: $narrativeArc, ')
          ..write('characters: $characters, ')
          ..write('insight: $insight, ')
          ..write('rigor: $rigor, ')
          ..write('engagement: $engagement, ')
          ..write('pro: $pro, ')
          ..write('con: $con, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EntriesTable entries = $EntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [entries];
}

typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      required String id,
      required String category,
      required String title,
      Value<String> creators,
      Value<int?> year,
      Value<String?> coverUrl,
      Value<String> source,
      Value<String?> externalId,
      Value<String?> externalRaw,
      Value<String> status,
      Value<String?> consumedDate,
      Value<int?> entertainment,
      Value<int?> thematicDepth,
      Value<int?> atmosphere,
      Value<int?> performances,
      Value<int?> narrativeArc,
      Value<int?> characters,
      Value<int?> insight,
      Value<int?> rigor,
      Value<int?> engagement,
      Value<String> pro,
      Value<String> con,
      Value<String> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<String> title,
      Value<String> creators,
      Value<int?> year,
      Value<String?> coverUrl,
      Value<String> source,
      Value<String?> externalId,
      Value<String?> externalRaw,
      Value<String> status,
      Value<String?> consumedDate,
      Value<int?> entertainment,
      Value<int?> thematicDepth,
      Value<int?> atmosphere,
      Value<int?> performances,
      Value<int?> narrativeArc,
      Value<int?> characters,
      Value<int?> insight,
      Value<int?> rigor,
      Value<int?> engagement,
      Value<String> pro,
      Value<String> con,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creators => $composableBuilder(
    column: $table.creators,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalRaw => $composableBuilder(
    column: $table.externalRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consumedDate => $composableBuilder(
    column: $table.consumedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entertainment => $composableBuilder(
    column: $table.entertainment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thematicDepth => $composableBuilder(
    column: $table.thematicDepth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get atmosphere => $composableBuilder(
    column: $table.atmosphere,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get performances => $composableBuilder(
    column: $table.performances,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get narrativeArc => $composableBuilder(
    column: $table.narrativeArc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get characters => $composableBuilder(
    column: $table.characters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get insight => $composableBuilder(
    column: $table.insight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rigor => $composableBuilder(
    column: $table.rigor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get engagement => $composableBuilder(
    column: $table.engagement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pro => $composableBuilder(
    column: $table.pro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get con => $composableBuilder(
    column: $table.con,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creators => $composableBuilder(
    column: $table.creators,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalRaw => $composableBuilder(
    column: $table.externalRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consumedDate => $composableBuilder(
    column: $table.consumedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entertainment => $composableBuilder(
    column: $table.entertainment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thematicDepth => $composableBuilder(
    column: $table.thematicDepth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get atmosphere => $composableBuilder(
    column: $table.atmosphere,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get performances => $composableBuilder(
    column: $table.performances,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get narrativeArc => $composableBuilder(
    column: $table.narrativeArc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get characters => $composableBuilder(
    column: $table.characters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get insight => $composableBuilder(
    column: $table.insight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rigor => $composableBuilder(
    column: $table.rigor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get engagement => $composableBuilder(
    column: $table.engagement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pro => $composableBuilder(
    column: $table.pro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get con => $composableBuilder(
    column: $table.con,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get creators =>
      $composableBuilder(column: $table.creators, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalRaw => $composableBuilder(
    column: $table.externalRaw,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get consumedDate => $composableBuilder(
    column: $table.consumedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entertainment => $composableBuilder(
    column: $table.entertainment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get thematicDepth => $composableBuilder(
    column: $table.thematicDepth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get atmosphere => $composableBuilder(
    column: $table.atmosphere,
    builder: (column) => column,
  );

  GeneratedColumn<int> get performances => $composableBuilder(
    column: $table.performances,
    builder: (column) => column,
  );

  GeneratedColumn<int> get narrativeArc => $composableBuilder(
    column: $table.narrativeArc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get characters => $composableBuilder(
    column: $table.characters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get insight =>
      $composableBuilder(column: $table.insight, builder: (column) => column);

  GeneratedColumn<int> get rigor =>
      $composableBuilder(column: $table.rigor, builder: (column) => column);

  GeneratedColumn<int> get engagement => $composableBuilder(
    column: $table.engagement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pro =>
      $composableBuilder(column: $table.pro, builder: (column) => column);

  GeneratedColumn<String> get con =>
      $composableBuilder(column: $table.con, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          Entry,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (Entry, BaseReferences<_$AppDatabase, $EntriesTable, Entry>),
          Entry,
          PrefetchHooks Function()
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> creators = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> externalRaw = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> consumedDate = const Value.absent(),
                Value<int?> entertainment = const Value.absent(),
                Value<int?> thematicDepth = const Value.absent(),
                Value<int?> atmosphere = const Value.absent(),
                Value<int?> performances = const Value.absent(),
                Value<int?> narrativeArc = const Value.absent(),
                Value<int?> characters = const Value.absent(),
                Value<int?> insight = const Value.absent(),
                Value<int?> rigor = const Value.absent(),
                Value<int?> engagement = const Value.absent(),
                Value<String> pro = const Value.absent(),
                Value<String> con = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                category: category,
                title: title,
                creators: creators,
                year: year,
                coverUrl: coverUrl,
                source: source,
                externalId: externalId,
                externalRaw: externalRaw,
                status: status,
                consumedDate: consumedDate,
                entertainment: entertainment,
                thematicDepth: thematicDepth,
                atmosphere: atmosphere,
                performances: performances,
                narrativeArc: narrativeArc,
                characters: characters,
                insight: insight,
                rigor: rigor,
                engagement: engagement,
                pro: pro,
                con: con,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required String title,
                Value<String> creators = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> externalRaw = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> consumedDate = const Value.absent(),
                Value<int?> entertainment = const Value.absent(),
                Value<int?> thematicDepth = const Value.absent(),
                Value<int?> atmosphere = const Value.absent(),
                Value<int?> performances = const Value.absent(),
                Value<int?> narrativeArc = const Value.absent(),
                Value<int?> characters = const Value.absent(),
                Value<int?> insight = const Value.absent(),
                Value<int?> rigor = const Value.absent(),
                Value<int?> engagement = const Value.absent(),
                Value<String> pro = const Value.absent(),
                Value<String> con = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                category: category,
                title: title,
                creators: creators,
                year: year,
                coverUrl: coverUrl,
                source: source,
                externalId: externalId,
                externalRaw: externalRaw,
                status: status,
                consumedDate: consumedDate,
                entertainment: entertainment,
                thematicDepth: thematicDepth,
                atmosphere: atmosphere,
                performances: performances,
                narrativeArc: narrativeArc,
                characters: characters,
                insight: insight,
                rigor: rigor,
                engagement: engagement,
                pro: pro,
                con: con,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      Entry,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (Entry, BaseReferences<_$AppDatabase, $EntriesTable, Entry>),
      Entry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
}
