import 'package:craftbeer/models/categories_data_notifier.dart';
import 'package:craftbeer/ui/search/categories_widget.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var categoriesData = Provider.of<CategoriesData>(context);
    return Column(
      children: [
        Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          direction: Axis.horizontal,
          children: categoriesData?.categories
              ?.map((e) => CategoryChip(
                  categoryName: e.name,
                  numBeers: e.beers?.length ?? 0,
                  onCategoryTap: () => categoriesData.updateSelection(e)))
              ?.toList(),
        ),
        Visibility(
          visible: categoriesData.selectedCategory != null,
          child: FilterBeersByTypeView(
            category: categoriesData.selectedCategory,
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String categoryName;
  final int numBeers;
  final Function onCategoryTap;

  CategoryChip(
      {@required this.categoryName,
      @required this.numBeers,
      @required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCategoryTap,
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: kGreenColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: numBeers != 0
                ? TextSpan(
                    style: TextStyle(color: kWhiteColor,),
                    children: [
                        TextSpan(
                          text: categoryName,
                        ),
                        TextSpan(text: " "),
                        TextSpan(
                            text: numBeers.toString(),)
                      ])
                : TextSpan(
                    style: TextStyle(
                        color: kBlackLightColor,
                        fontWeight: FontWeight.bold),
                    children: [
                        TextSpan(text: categoryName),
                      ]),
          ),
        ),
      ),
    );
  }
}
