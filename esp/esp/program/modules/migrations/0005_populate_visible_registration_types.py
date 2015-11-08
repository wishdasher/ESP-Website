# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


def populate_field(apps, schema_editor):
    Tag = apps.get_model('tagdict', 'Tag')
    RegistrationType = apps.get_model('program', 'RegistrationType')
    Program = apps.get_model('program', 'Program')
    StudentClassRegModuleInfo = apps.get_model('modules',
                                               'StudentClassRegModuleInfo')
    enrolled = RegistrationType.objects.get(name='Enrolled')
    for tag in Tag.objects.filter(key='display_registration_names'):
        # TODO: how to set a default for a M2M
        


class Migration(migrations.Migration):

    dependencies = [
        ('modules', '0004_studentclassregmoduleinfo_visible_registration_types'),
        ('tagdict', '0001_initial'),
    ]

    operations = [
        RunPython(populate_field, populate_tag),
    ]
