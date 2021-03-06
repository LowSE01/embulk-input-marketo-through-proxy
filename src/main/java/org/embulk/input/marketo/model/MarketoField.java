package org.embulk.input.marketo.model;

import com.google.common.base.Optional;
import org.embulk.input.marketo.MarketoUtils;
import org.embulk.spi.type.Type;
import org.embulk.spi.type.Types;

/**
 * Created by tai.khuu on 9/22/17.
 */

public class MarketoField
{
    private String name;

    private MarketoDataType marketoDataType;

    public MarketoField(){}

    public MarketoField(String name, String dataType)
    {
        this.name = name;
        try {
            marketoDataType = MarketoDataType.valueOf(dataType.toUpperCase());
        }
        catch (IllegalArgumentException ex) {
            marketoDataType = MarketoDataType.STRING;
        }
    }

    public MarketoField(String name, MarketoDataType marketoDataType)
    {
        this.name = name;
        this.marketoDataType = marketoDataType;
    }

    public String getName()
    {
        return name;
    }

    public MarketoDataType getMarketoDataType()
    {
        return marketoDataType;
    }

    @Override
    public boolean equals(Object o)
    {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        MarketoField field = (MarketoField) o;

        if (name != null ? !name.equals(field.name) : field.name != null) {
            return false;
        }
        return marketoDataType == field.marketoDataType;
    }

    @Override
    public int hashCode()
    {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + (marketoDataType != null ? marketoDataType.hashCode() : 0);
        return result;
    }

    public enum MarketoDataType
    {
        DATETIME(Types.TIMESTAMP, MarketoUtils.MARKETO_DATE_TIME_FORMAT),
        EMAIL(Types.STRING),
        FLOAT(Types.DOUBLE),
        INTEGER(Types.LONG),
        FORMULA(Types.STRING),
        PERCENT(Types.DOUBLE),
        URL(Types.STRING),
        PHONE(Types.STRING),
        TEXTAREA(Types.STRING),
        TEXT(Types.STRING),
        STRING(Types.STRING),
        SCORE(Types.LONG),
        BOOLEAN(Types.BOOLEAN),
        CURRENCY(Types.DOUBLE),
        DATE(Types.TIMESTAMP, MarketoUtils.MARKETO_DATE_FORMAT),
        REFERENCE(Types.STRING);

        private Type type;

        private String format;

        MarketoDataType(Type type, String format)
        {
            this.type = type;
            this.format = format;
        }

        MarketoDataType(Type type)
        {
            this.type = type;
        }

        public Type getType()
        {
            return type;
        }

        public Optional<String> getFormat()
        {
            return Optional.fromNullable(format);
        }
    }

    @Override
    public String toString()
    {
        return "MarketoField{" +
                "name='" + name + '\'' +
                ", marketoDataType=" + marketoDataType +
                '}';
    }
}
