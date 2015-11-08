# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('program', '0003_auto_20151108_1612'),
        ('modules', '0003_auto_20151004_1715'),
    ]

    operations = [
        migrations.AddField(
            model_name='studentclassregmoduleinfo',
            name='visible_registration_types',
            field=models.ManyToManyField(help_text=b'RegistrationTypes that will be visible to students on the student registration pages.', related_name='_visible_registration_types_+', null=True, to='program.RegistrationType'),
        ),
    ]
