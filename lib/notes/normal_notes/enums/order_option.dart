enum OrderOption {
  updatedAt,
  createdAt;

  String get label {
    return switch (this) {
      OrderOption.updatedAt => 'Modified Date',
      OrderOption.createdAt => 'Created Date',
    };
  }
}
