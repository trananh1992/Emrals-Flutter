class StatsModel {
  final int cities;
  final int countries;
  final int cleanups;
  final int reports;
  final int users;
  final int emralsWon;
  final int emralsAdded;
  final int eCans;
  final int tosses;
  final int scans;
  final int barcodes;

 /*  StatsModel(
      this.cities,
      this.countries,
      this.cleanups,
      this.reports,
      this.users,
      this.emrals_won,
      this.emrals_added,
      this.e_cans,
      this.tosses,
      this.scans,
      this.barcodes); */

  StatsModel.fromJson(Map json)
      : eCans = json['eCans'],
        cities = json['zones'],
        reports = json['reports'],
        cleanups = json['cleanups'],
        scans = json['scans'],
        tosses = json['tosses'],
        barcodes = json['barcodes'],
        users = json['users'],
        emralsWon = json['emrals_won'],
        emralsAdded = json['emrals_added'],
        countries = json['zones'];
}
