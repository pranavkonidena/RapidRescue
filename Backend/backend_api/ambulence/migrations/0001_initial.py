# Generated by Django 5.0.3 on 2024-03-08 19:08

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Ambulance',
            fields=[
                ('number_plate', models.CharField(max_length=20, primary_key=True, serialize=False)),
                ('current_location_latitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('current_location_longitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('is_active', models.BooleanField(default=False)),
                ('is_assigned', models.BooleanField(default=False)),
                ('assigned_location_latitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
                ('assigned_location_longitude', models.DecimalField(blank=True, decimal_places=6, max_digits=9, null=True)),
            ],
        ),
    ]
