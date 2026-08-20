const { QueryTypes } = require("sequelize");
const { sequelize } = require("../../models");

const syncSkills = async (skills = {}) => {
  const technicalSkills = [
    ...new Set(
      (skills.technical || [])
        .map((skill) => skill?.trim())
        .filter(Boolean)
    ),
  ];

  const softSkills = [
    ...new Set(
      (skills.soft || [])
        .map((skill) => skill?.trim())
        .filter(Boolean)
    ),
  ];

  if (!technicalSkills.length && !softSkills.length) {
    return;
  }

  await sequelize.query(
    `
    INSERT INTO public."reqSkills"
    (
      "skillName",
      "typeId",
      "type"
    )
    SELECT
      "skillName",
      "typeId",
      type
    FROM
    (
      SELECT
        unnest($1::varchar[]) AS "skillName",
        2 AS "typeId",
        'technical' AS type

      UNION ALL

      SELECT
        unnest($2::varchar[]) AS "skillName",
        1 AS "typeId",
        'soft' AS type
    ) AS incoming
    WHERE NOT EXISTS
    (
      SELECT 1
      FROM public."reqSkills" AS existing
      WHERE LOWER(existing."skillName") = LOWER(incoming."skillName")
        AND existing."typeId" = incoming."typeId"
    );
    `,
    {
      bind: [technicalSkills, softSkills],
      type: QueryTypes.INSERT,
    }
  );
};

module.exports = { syncSkills };
