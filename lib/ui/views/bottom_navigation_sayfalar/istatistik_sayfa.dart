import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/ui/cubit/istatistik_sayfa_cubit.dart';

class IstatistikSayfa extends StatefulWidget {
  const IstatistikSayfa({super.key});

  @override
  State<IstatistikSayfa> createState() => _IstatistikSayfaState();
}

class _IstatistikSayfaState extends State<IstatistikSayfa> {
  DateTime secilenTarih = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    context.read<IstatistikSayfaCubit>().getIstatistikVerisi(secilenTarih);
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height; //707.4285714285714 18:39.3 5: 141.49 16: 44.21 80: 8.84 40: 17.69 50: 14.15 20: 35.37 14: 50.53 8: 88.43 30: 23.58
    final double ekranGenisligi = ekranBilgisi.size.width; //411.42857142857144 50: 8.23 20: 20.57 16: 25.71

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? yeniTarih = await showDatePicker(
                context: context,
                initialDate: secilenTarih,
                firstDate: DateTime(2023),
                lastDate: DateTime(2030),
              );
              if (yeniTarih != null) {
                setState(() {
                  secilenTarih = yeniTarih;
                });
                context.read<IstatistikSayfaCubit>().getIstatistikVerisi(yeniTarih);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(ekranYuksekligi/44.21), //16
        child: BlocBuilder<IstatistikSayfaCubit, List<Map<String, dynamic>>>(
          builder: (context, istatistikler) {
            if (istatistikler.isEmpty) {
              return const Center(child: Text("Bu hafta için veri yok."));
            }
            final List<int> tarihNumaralari = List.generate(7, (i) {
              final gun = secilenTarih.subtract(Duration(days: secilenTarih.weekday - 1)).add(Duration(days: i));
              return gun.day;
            });

            return ListView.builder(
              itemCount: istatistikler.length,
              itemBuilder: (context, index) {
                final ilac = istatistikler[index];
                final gunlerMap = Map<int, int>.from(ilac["gunler"]);
                final ilacIsim = ilac["ilacIsim"];

                return Padding(
                  padding: EdgeInsets.only(bottom: ekranYuksekligi/23.58), //30
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ilacIsim,
                        style: TextStyle(fontSize: ekranYuksekligi/35.37, fontWeight: FontWeight.bold), //20
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                      SizedBox(height: ekranYuksekligi/50.53), //14
                      SizedBox(
                        height: ekranYuksekligi/2.83, //250
                        child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceBetween,
                              barGroups: _buildBarGroupForSingleIlac(gunlerMap, ekranGenisligi),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      int index = value.toInt();
                                      if (index < 0 || index >= tarihNumaralari.length) return const SizedBox.shrink();
                                      return Text(tarihNumaralari[index].toString());
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      if (value % 1 != 0) return const SizedBox.shrink();
                                      return Text(value.toInt().toString());
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                            ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }



  List<BarChartGroupData> _buildBarGroupForSingleIlac(Map<int, int> gunVeri, double ekranGenisligi) {
    List<BarChartGroupData> gruplar = [];

    for (int i = 0; i < 7; i++) {
      double miktar = (gunVeri[i] ?? 0).toDouble();

      gruplar.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: miktar,
              width: ekranGenisligi/25.71, //16
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return gruplar;
  }
}
